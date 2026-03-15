require 'spec_helper'

describe FeedController do
  before :each do
    @user = FactoryBot.create(:user)
    @channel = FactoryBot.create(:channel)
    now = Time.utc(2013,1,1)
    @feed1 = FactoryBot.create(:feed, :field1 => 10, :channel => @channel, :created_at => now, :entry_id => 1)
    @feed = FactoryBot.create(:feed, :field1 => 10, :channel => @channel, :created_at => now, :entry_id => 2)
    @feed = FactoryBot.create(:feed, :field1 => 9, :channel => @channel, :created_at => now, :entry_id => 3)
    @feed = FactoryBot.create(:feed, :field1 => 7, :channel => @channel, :created_at => now, :entry_id => 4)
    @feed = FactoryBot.create(:feed, :field1 => 6, :channel => @channel, :created_at => now, :entry_id => 5)
    @feed = FactoryBot.create(:feed, :field1 => 5, :channel => @channel, :created_at => now, :entry_id => 6)
    @feed = FactoryBot.create(:feed, :field1 => 4, :channel => @channel, :created_at => now, :entry_id => 7)
    @channel.last_entry_id = @feed.entry_id
    @channel.field1 = 'temp'
    @channel.save

    @user.channels.push @channel
    @tag = FactoryBot.create(:tag)
    @apikey = FactoryBot.create(:api_key)
    allow(controller).to receive(:current_user).and_return(@user)
    allow(controller).to receive(:current_user_session).and_return(true)

  end

  it "should get first feed" do
    get :show, params: { id: @feed1.id, channel_id: @channel.id, format: 'json' }
    expect(response).to be_successful
    expect(response.body).to eq("{\"created_at\":\"2013-01-01T00:00:00+00:00\",\"entry_id\":1,\"field1\":\"10\"}" )
  end

  it "should get last feed" do
    get :show, params: { id: 'last', channel_id: @channel.id, format: 'json' }
    expect(response).to be_successful
    expect(response.body).to eq("{\"created_at\":\"2013-01-01T00:00:00+00:00\",\"entry_id\":7,\"field1\":\"4\"}" )
  end

  it "should get last feed (html)" do
    get :show, params: { id: 'last', channel_id: @channel.id, field_id: 1 }
    expect(response).to be_successful
    expect(response.body).to eq("4" )
  end

  it "should get last feed (html), no field_id specified" do
    get :show, params: { id: 'last', channel_id: @channel.id }
    expect(response).to be_successful
    expect(response.body).to eq("{\"created_at\":\"2013-01-01T00:00:00+00:00\",\"entry_id\":7,\"field1\":\"4\"}" )
  end

  it "should get feed last_average" do
    get :last_average, params: { channel_id: @channel.id, average: 10 }
    expect(response).to be_successful
    jsonResponse = JSON.parse(response.body)

    expect(jsonResponse["field1"]).to eq("7.285714285714286")

  end

  it "should get last_median" do
    get :last_median, params: { channel_id: @channel.id, median: 10 }
    expect(response).to be_successful
    jsonResponse = JSON.parse(response.body)
    expect(jsonResponse["field1"]).to eq("7.0")
  end

  it "should get last_sum" do
    get :last_sum, params: { channel_id: @channel.id, sum: 10 }
    expect(response).to be_successful
    jsonResponse = JSON.parse(response.body)
    expect(jsonResponse["field1"]).to eq("51.0")
  end

end
