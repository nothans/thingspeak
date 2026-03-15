require 'spec_helper'

describe FeedHelper do
  describe "feed_select_data" do
    before :each do
      @channel = FactoryBot.create(:channel)
    end
    it "extracts selection criteria from the request parameters with no time params" do
      #params = {:average => 10}
      allow(helper).to receive(:params).and_return(params)
      only = Feed.select_options(@channel, params)
      expect(only).to include(:created_at, :entry_id)
    end
    it "extracts selection criteria from the request parameters " do
      params = {:average => 10}
      allow(helper).to receive(:params).and_return(params)
      only = Feed.select_options(@channel, params)
      expect(only).to include(:created_at)
    end
  end
  describe "feeds_into_averages" do
    before :each do
      userAttr = FactoryBot.attributes_for(:user)
      @user = User.create!(userAttr)

      @channel = FactoryBot.create(:channel, :user => @user)
      now = Time.utc(2013,1,1)
      feed1 = FactoryBot.create(:feed, :channel => @channel, :created_at => now)
      feed2 = FactoryBot.create(:feed, :channel => @channel, :created_at => now - 5.minutes)
      feed3 = FactoryBot.create(:feed, :channel => @channel, :created_at => now - 8.minutes)
    end

    it "averages feed values based on a timeslice" do
      feeds = Feed.order(:created_at).to_a
      params = {:average => 10}
      allow(helper).to receive(:params).and_return(params)

      timeslices = helper.feeds_into_averages(feeds, params)
      expect(timeslices.size).to eq(2)
    end
  end
  describe "feeds_into_median" do
    before :each do
      userAttr = FactoryBot.attributes_for(:user)
      @user = User.create!(userAttr)

      @channel = FactoryBot.create(:channel, :user => @user)
      now = Time.utc(2013,1,1)
      feed1 = FactoryBot.create(:feed, :channel => @channel, :created_at => now)
      feed2 = FactoryBot.create(:feed, :channel => @channel, :created_at => now - 5.minutes)
      feed3 = FactoryBot.create(:feed, :channel => @channel, :created_at => now - 8.minutes)
    end

    it "median feed values based on a timeslice" do
      feeds = Feed.order(:created_at).to_a
      params = {:median => 10}
      allow(helper).to receive(:params).and_return(params)

      timeslices = helper.feeds_into_medians(feeds, params)
      expect(timeslices.size).to eq(2)
    end
  end
  describe "feeds_into_sums" do
    before :each do
      userAttr = FactoryBot.attributes_for(:user)
      @user = User.create!(userAttr)

      @channel = FactoryBot.create(:channel, :user => @user)
      now = Time.utc(2013,1,1)
      feed1 = FactoryBot.create(:feed, :channel => @channel, :created_at => now)
      feed2 = FactoryBot.create(:feed, :channel => @channel, :created_at => now - 5.minutes)
      feed3 = FactoryBot.create(:feed, :channel => @channel, :created_at => now - 8.minutes)
    end

    it "sum feed values based on a timeslice" do
      feeds = Feed.order(:created_at).to_a
      params = {:sum => 10}
      allow(helper).to receive(:params).and_return(params)

      timeslices = helper.feeds_into_sums(feeds, params)
      expect(timeslices.size).to eq(2)
    end
  end
  describe "feeds_into_timescales" do
    before :each do
      userAttr = FactoryBot.attributes_for(:user)
      @user = User.create!(userAttr)

      @channel = FactoryBot.create(:channel, :user => @user)
      now = Time.utc(2013,1,1)
      feed1 = FactoryBot.create(:feed, :channel => @channel, :created_at => now)
      feed2 = FactoryBot.create(:feed, :channel => @channel, :created_at => now - 5.minutes)
      feed3 = FactoryBot.create(:feed, :channel => @channel, :created_at => now - 8.minutes)
    end

    it "timescale feed values based on a timeslice" do
      feeds = Feed.order(:created_at).to_a
      params = {:timescale => 10}
      allow(helper).to receive(:params).and_return(params)

      timeslices = helper.feeds_into_timescales(feeds, params)
      expect(timeslices.size).to eq(2)
    end
  end
end
