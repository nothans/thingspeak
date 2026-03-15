require 'spec_helper'

describe ChannelsController do

  describe "Logged In" do
    before :each do
      @user = FactoryBot.create(:user)
      @channel = FactoryBot.create(:channel)
      @user.channels.push @channel
      @tag = FactoryBot.create(:tag)
      @apikey = FactoryBot.create(:api_key)
      allow(controller).to receive(:current_user).and_return(@user)
      allow(controller).to receive(:current_user_session).and_return(true)

    end
    it "should show the channels private page" do
      get :show, params: { id: @channel.id }
      expect(response).to render_template(:private_show)
    end

    it "should allow a new channel to be created" do
      post :create, params: {}
      channel = Channel.last
      expect(response).to be_redirect
      expect(response).to redirect_to( channel_path(channel.id, :anchor => "channelsettings"))
      expect(channel.windows.where(window_type: 'chart').count).to eq(2)
    end

    it 'should not allow channel to be updated with invalid parameters' do
      @channel.update({video_type: nil, video_id: nil})
      put :update, params: { id: @channel, channel: {video_id: 'invalid_id'} }
      expect(flash[:alert]).to match /#{I18n.t(:channel_video_type_blank)}/
    end


    it "should allow a channel to be edited" do
      @channel.public_flag = true
      put :update, params: { id: @channel, channel: {name: 'new name'}, tags: FactoryBot.attributes_for(:tag) }
      @channel.reload
      expect(@channel.name).to eq('new name')
      expect(response).to redirect_to channel_path(@channel.id)
      expect(flash[:notice]).to eq(I18n.t(:channel_update_success))
    end

    it "should allow a channel to be deleted " do
      delete :destroy, params: { id: @channel.id }
      expect(response).to redirect_to channels_path
      @channel_no_more = Channel.find_by_id(@channel.id)
      expect(@channel_no_more).to be_nil
    end
  end

  describe "Not Logged In" do
    before :each do
      without_timestamping_of Channel do
        @channel = FactoryBot.create(:channel, :updated_at => Time.now - RATE_LIMIT_FREQUENCY.to_i.seconds, :public_flag => false)
      end
      @apikey = FactoryBot.create(:api_key, :channel => @channel)
    end

    it "should only display public channels" do
      get :public, params: {}
      expect(response).to render_template('public')
    end

    it "should show paginated list of public channels as json" do
      get :public, params: { format: :json }
      expect(JSON.parse(response.body).keys.include?('pagination')).to be_truthy
    end

    it "should show the channels public page" do
      get :show, params: { id: @channel.id }
      expect(response).to render_template(:public_show)
    end

    it "should redirect to login when creating a new channel" do
      post :create, params: {}

      expect(response).to be_redirect
      expect(response).to redirect_to(login_path)
      expect(response.status).to eq(302)
    end

    it "should be allowed to send data via get to update channel" do
      get :post_data, params: { key: "0S5G2O7FAB5K0J6Z", field1: "0", status: "ThisIsATest" }

      expect(response.body.to_i).to be > 0
      expect(response).to be_successful
    end

    if defined?(React)
      describe "updates a channel and executes a TalkBack command" do
        before :each do
          @talkback = FactoryBot.create(:talkback)
          @command = FactoryBot.create(:command)
          @command2 = FactoryBot.create(:command, :position => nil, :command_string => 'quote"test')
        end

        it 'returns the command string' do
          post :post_data, params: { key: '0S5G2O7FAB5K0J6Z', field1: '70', talkback_key: @talkback.api_key }
          expect(response.body).to eq("MyString")
        end
        it 'returns JSON' do
          post :post_data, params: { key: '0S5G2O7FAB5K0J6Z', field1: '70', talkback_key: @talkback.api_key, format: 'json' }
          expect(JSON.parse(response.body)['command_string']).to eq("MyString")
          expect(JSON.parse(response.body)['position']).to eq(nil)
          expect(JSON.parse(response.body)['executed_at']).not_to eq(nil)
        end
        it 'returns XML' do
          post :post_data, params: { key: '0S5G2O7FAB5K0J6Z', field1: '70', talkback_key: @talkback.api_key, format: 'xml' }
          expect(Nokogiri::XML(response.body).css('command-string').text).to eq("MyString")
          expect(Nokogiri::XML(response.body).css('position').text).to eq('')
          expect(Nokogiri::XML(response.body).css('executed-at').text).not_to eq('')
        end
      end
    end

  end

  describe "API" do
    before :each do
      @user = FactoryBot.create(:user)
      @channel = FactoryBot.create(:channel)
      @feed = FactoryBot.create(:feed, :field1 => 10, :channel => @channel)
    end

    describe "list channels" do
      it "should not list my channels" do
        get :index, params: { api_key: 'INVALID', format: 'json' }
        expect(response.status).to eq(401)
      end

      it "lists my channels" do
        get :index, params: { api_key: @user.api_key, format: 'json' }
        expect(response).to be_successful
      end

      it "searches nearby public channels" do
        channel1 = Channel.create(name: 'channel1', latitude: 10, longitude: 10, public_flag: true)
        channel2 = Channel.create(name: 'channel2', latitude: 60, longitude: 60, public_flag: true)
        get :public, params: { api_key: @user.api_key, latitude: 59.8, longitude: 60.2, distance: 100, format: 'json' }
        expect(JSON.parse(response.body)['channels'][0]['name']).to eq("channel2")
      end
    end

    describe "show channel" do
      it 'shows a channel' do
        get :show, params: { id: @channel.id }
        expect(response).to be_successful
      end
      it 'returns JSON' do
        get :show, params: { id: @channel.id, format: 'json' }
        expect(JSON.parse(response.body)['name']).to eq(@channel.name)
        expect(JSON.parse(response.body)['api_keys']).to be_nil
      end
      it 'returns JSON with private data' do
        get :show, params: { id: @channel.id, api_key: @user.api_key, format: 'json' }
        expect(JSON.parse(response.body)['api_keys']).not_to be_nil
      end
      it 'returns XML' do
        get :show, params: { id: @channel.id, format: 'xml' }
        expect(Nokogiri::XML(response.body).css('name').text).to eq(@channel.name)
        expect(Nokogiri::XML(response.body).css('api-keys').text).to be_blank
      end
      it 'returns XML with private data' do
        @channel.add_write_api_key
        get :show, params: { id: @channel.id, api_key: @user.api_key, format: 'xml' }
        expect(Nokogiri::XML(response.body).css('api-keys').text).not_to be_blank
      end
    end

    describe "create channel" do
      it 'creates a channel' do
        post :create, params: { key: @user.api_key, name: 'mychannel' }
        expect(response).to be_redirect
        channel_id = Channel.all.last.id
        expect(response).to redirect_to(channel_path(channel_id, :anchor => "channelsettings"))
      end
      it 'returns JSON' do
        post :create, params: { key: @user.api_key, name: 'mychannel', format: 'json' }
        expect(Channel.last.ranking).not_to be_blank
        expect(JSON.parse(response.body)['name']).to eq("mychannel")
      end
      it 'returns XML' do
        post :create, params: { key: @user.api_key, name: 'mychannel', description: 'mydesc', format: 'xml' }
        expect(Nokogiri::XML(response.body).css('description').text).to eq("mydesc")
      end
    end

    describe "update channel" do
      it 'updates a channel' do
        post :update, params: { id: @channel.id, key: @user.api_key, name: 'newname' }
        expect(response).to be_redirect
        @channel.reload
        expect(@channel.name).to eq("newname")
        channel_id = Channel.all.last.id
        expect(response).to redirect_to(channel_path(channel_id))
      end
      it 'returns JSON' do
        post :update, params: { id: @channel.id, key: @user.api_key, name: 'newname', format: 'json' }
        expect(Channel.last.ranking).not_to be_blank
        expect(JSON.parse(response.body)['name']).to eq("newname")
      end
      it 'returns XML' do
        post :update, params: { id: @channel.id, key: @user.api_key, name: 'newname', format: 'xml' }
        expect(Nokogiri::XML(response.body).css('name').text).to eq("newname")
      end
    end

    describe "clear channel" do
      it 'clears a channel' do
        expect(@channel.feeds.count).to eq(1)
        delete :clear, params: { id: @channel.id, key: @user.api_key }
        expect(@channel.feeds.count).to eq(0)
        expect(response).to be_redirect
        expect(response).to redirect_to(channel_path(@channel.id))
      end
      it 'returns JSON' do
        expect(@channel.feeds.count).to eq(1)
        delete :clear, params: { id: @channel.id, key: @user.api_key, format: 'json' }
        expect(@channel.feeds.count).to eq(0)
        expect(JSON.parse(response.body)).to eq([])
      end
      it 'returns XML' do
        expect(@channel.feeds.count).to eq(1)
        delete :clear, params: { id: @channel.id, key: @user.api_key, format: 'xml' }
        expect(@channel.feeds.count).to eq(0)
        expect(Nokogiri::XML(response.body).css('nil-classes').text).to eq('')
      end
    end

    describe "delete channel" do
      it 'deletes a channel' do
        delete :destroy, params: { id: @channel.id, key: @user.api_key }
        expect(Channel.find_by_id(@channel.id)).to be_nil
        expect(response).to be_redirect
        expect(response).to redirect_to(channels_path)
      end
      it 'returns JSON' do
        delete :destroy, params: { id: @channel.id, key: @user.api_key, format: 'json' }
        expect(Channel.find_by_id(@channel.id)).to be_nil
        expect(JSON.parse(response.body)['name']).to eq(@channel.name)
      end
      it 'returns XML' do
        delete :destroy, params: { id: @channel.id, key: @user.api_key, format: 'xml' }
        expect(Channel.find_by_id(@channel.id)).to be_nil
        expect(Nokogiri::XML(response.body).css('name').text).to eq(@channel.name)
      end
    end

  end

end
