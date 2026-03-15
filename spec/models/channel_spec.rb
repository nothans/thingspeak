# encoding: UTF-8
# == Schema Information
#
# Table name: channels
#
#  id                        :integer          not null, primary key
#  user_id                   :integer
#  name                      :string(255)
#  description               :string(255)
#  latitude                  :decimal(15, 10)
#  longitude                 :decimal(15, 10)
#  field1                    :string(255)
#  field2                    :string(255)
#  field3                    :string(255)
#  field4                    :string(255)
#  field5                    :string(255)
#  field6                    :string(255)
#  field7                    :string(255)
#  field8                    :string(255)
#  scale1                    :integer
#  scale2                    :integer
#  scale3                    :integer
#  scale4                    :integer
#  scale5                    :integer
#  scale6                    :integer
#  scale7                    :integer
#  scale8                    :integer
#  created_at                :datetime
#  updated_at                :datetime
#  elevation                 :string(255)
#  last_entry_id             :integer
#  public_flag               :boolean          default(FALSE)
#  options1                  :string(255)
#  options2                  :string(255)
#  options3                  :string(255)
#  options4                  :string(255)
#  options5                  :string(255)
#  options6                  :string(255)
#  options7                  :string(255)
#  options8                  :string(255)
#  social                    :boolean          default(FALSE)
#  slug                      :string(255)
#  status                    :string(255)
#  url                       :string(255)
#  video_id                  :string(255)
#  video_type                :string(255)
#  clearing                  :boolean          default(FALSE), not null
#  ranking                   :integer
#  user_agent                :string(255)
#  realtime_io_serial_number :string(36)
#  metadata                  :text
#  last_write_at             :datetime
#

require 'spec_helper'

describe Channel do
  it "should be valid" do
    channel = Channel.new
    expect(channel).to be_valid
  end

  it "should set ranking correctly" do
    channel = Channel.create
    expect(channel.set_ranking).to eq(15)
    channel.description = "foo"
    expect(channel.set_ranking).to eq(35)
  end

  it "should accept utf8" do
    channel = Channel.create(:name => "ǎ")
    channel.reload
    expect(channel.name).to eq("ǎ")
  end

  it "should have no plugins when created" do
    channel = Channel.create
    channel.set_windows
    channel.save
    expect(channel.name).to eq("Channel #{channel.id}")
    expect(channel.windows.size).to eq(2)
  end

  it "should have video iframe after updated" do
    channel = Channel.create!
    video_id = "xxxxxx"
    channel.assign_attributes({:video_id => video_id, :video_type => "youtube"})
    channel.set_windows
    channel.save
    window = channel.windows.where({:window_type => :video })
    expect(window[0].html).to eq("<iframe class=\"youtube-player\" type=\"text/html\" width=\"452\" height=\"260\" src=\"https://www.youtube.com/embed/xxxxxx?wmode=transparent\" frameborder=\"0\" wmode=\"Opaque\" ></iframe>")
  end

  it "should have private windows" do
    channel = Channel.create!
    channel.assign_attributes({:field1 => "Test"})
    channel.set_windows
    channel.save
    showFlag = true
    expect(channel.private_windows(showFlag).count).to eq(2) #2 private windows - 1 field and 1 status
  end

  # this is necessary so that the existing API is not broken
  # https://thingspeak.com/channels/9/feed.json?results=10 should have 'channel' as the first key
  it "should include root in json by default" do
    channel = Channel.create
    expect(channel.as_json.keys.include?('channel')).to be_truthy
  end

  it "should not include root using public_options" do
    channel = Channel.create
    expect(channel.as_json(Channel.public_options).keys.include?('channel')).to be_falsey
  end

  describe 'testing scopes' do
    before :each do
      @public_channel = FactoryBot.create(:channel, :public_flag => true, :last_entry_id => 10)
      @private_channel = FactoryBot.create(:channel, :public_flag => false, :last_entry_id => 10)
    end
    it 'should show public channels' do
      channels = Channel.public_viewable
      expect(channels.count).to eq(1)
    end
    it 'should show active channels' do
      channels = Channel.active
      expect(channels.count).to eq(2)
    end
    it 'should show selected channels' do
      channels = Channel.by_array([@public_channel.id, @private_channel.id])
      expect(channels.count).to eq(2)
    end
    it 'should show tagged channels' do
      @public_channel.save_tags('sensor')
      channels = Channel.with_tag('sensor')
      expect(channels.count).to eq(1)
    end
  end

  describe 'geolocation' do
    it 'should find nearby channels' do
      channel1 = Channel.create(latitude: 10, longitude: 10, public_flag: true)
      channel2 = Channel.create(latitude: 60, longitude: 60, public_flag: true)
      channel3 = Channel.create(latitude: 60, longitude: 60, public_flag: false)
      expect(Channel.location_search({latitude: 9.8, longitude: 10.2, distance: 100}).first).to eq(channel1)
      expect(Channel.location_search({latitude: 60.2, longitude: 59.8, distance: 100}).first).to eq(channel2)
      expect(Channel.location_search({latitude: 60.2, longitude: 59.8, distance: 100}).count).to eq(1)
      expect(Channel.location_search({latitude: 30.8, longitude: 30.2, distance: 100}).count).to eq(0)
    end
  end

  describe 'value_from_string' do
    before :each do
      @user = FactoryBot.create(:user)
      @channel = FactoryBot.create(:channel, public_flag: false, user_id: @user.id)
      @feed = FactoryBot.create(:feed, field1: 7, channel_id: @channel.id)
    end

    it 'should get the last value correctly' do
      expect(Channel.value_from_string("channel_#{@channel.id}_field_1", @user)).to eq('7')
    end

    it 'has an incorrect user' do
      expect(Channel.value_from_string("channel_#{@channel.id}_field_1", nil)).to eq(nil)
    end

    it 'has an incorrect user, but channel is public' do
      @channel.update_column(:public_flag, true)
      expect(Channel.value_from_string("channel_#{@channel.id}_field_1", nil)).to eq('7')
    end

    it 'has an incorrect string' do
      expect(Channel.value_from_string("channel_#{@channel.id}_field", @user)).to eq(nil)
    end

    it 'has an incorrect field' do
      expect(Channel.value_from_string("channel_#{@channel.id}_field_8", @user)).to eq(nil)
    end
  end
end
