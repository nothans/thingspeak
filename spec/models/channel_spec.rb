# encoding: UTF-8
require 'spec_helper'

describe Channel do
  let(:user) { FactoryBot.create(:user) }

  it "should be valid" do
    channel = Channel.new(user: user)
    expect(channel).to be_valid
  end

  it "should set ranking correctly" do
    channel = FactoryBot.create(:channel, user: user)
    expect(channel.set_ranking).to eq(15)
    channel.description = "foo"
    expect(channel.set_ranking).to eq(35)
  end

  it "should accept utf8" do
    channel = FactoryBot.create(:channel, name: "ǎ", user: user)
    channel.reload
    expect(channel.name).to eq("ǎ")
  end

  it "should create default windows" do
    channel = FactoryBot.create(:channel, user: user)
    channel.set_windows
    channel.save
    expect(channel.name).to eq("Channel name")
    expect(channel.windows.size).to eq(2)
  end

  it "should have video iframe after updated" do
    channel = FactoryBot.create(:channel, user: user)
    channel.assign_attributes(video_id: "xxxxxx", video_type: "youtube")
    channel.set_windows
    channel.save
    window = channel.windows.where(window_type: :video)
    expect(window[0].html).to eq("<iframe class=\"youtube-player\" type=\"text/html\" width=\"452\" height=\"260\" src=\"https://www.youtube.com/embed/xxxxxx?wmode=transparent\" frameborder=\"0\" wmode=\"Opaque\" ></iframe>")
  end

  it "should have private windows" do
    channel = FactoryBot.create(:channel, user: user)
    channel.assign_attributes(field1: "Test")
    channel.set_windows
    channel.save
    expect(channel.private_windows(true).count).to eq(2)
  end

  it "should include root in json by default" do
    channel = FactoryBot.create(:channel, user: user)
    expect(channel.as_json.keys.include?('channel')).to be_truthy
  end

  it "should not include root using public_options" do
    channel = FactoryBot.create(:channel, user: user)
    expect(channel.as_json(Channel.public_options).keys.include?('channel')).to be_falsey
  end

  describe 'testing scopes' do
    before :each do
      @public_channel = FactoryBot.create(:channel, public_flag: true, last_entry_id: 10)
      @private_channel = FactoryBot.create(:channel, public_flag: false, last_entry_id: 10)
    end
    it 'should show public channels' do
      expect(Channel.public_viewable.count).to eq(1)
    end
    it 'should show active channels' do
      expect(Channel.active.count).to eq(2)
    end
    it 'should show selected channels' do
      expect(Channel.by_array([@public_channel.id, @private_channel.id]).count).to eq(2)
    end
    it 'should show tagged channels' do
      @public_channel.save_tags('sensor')
      expect(Channel.with_tag('sensor').count).to eq(1)
    end
  end

  describe 'geolocation' do
    it 'should find nearby channels' do
      channel1 = FactoryBot.create(:channel, latitude: 10, longitude: 10, public_flag: true)
      channel2 = FactoryBot.create(:channel, latitude: 60, longitude: 60, public_flag: true)
      channel3 = FactoryBot.create(:channel, latitude: 60, longitude: 60, public_flag: false)
      expect(Channel.location_search({latitude: 9.8, longitude: 10.2, distance: 100}).first).to eq(channel1)
      expect(Channel.location_search({latitude: 60.2, longitude: 59.8, distance: 100}).first).to eq(channel2)
      expect(Channel.location_search({latitude: 60.2, longitude: 59.8, distance: 100}).count).to eq(1)
      expect(Channel.location_search({latitude: 30.8, longitude: 30.2, distance: 100}).count).to eq(0)
    end
  end

  describe 'value_from_string' do
    before :each do
      @user = FactoryBot.create(:user)
      @channel = FactoryBot.create(:channel, public_flag: false, user: @user)
      @feed = FactoryBot.create(:feed, field1: 7, channel: @channel)
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
