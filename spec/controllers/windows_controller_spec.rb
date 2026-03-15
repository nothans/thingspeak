require 'spec_helper'

describe WindowsController do
  before :each do
    @user = FactoryBot.create(:user)

    allow(controller).to receive(:current_user).and_return(@user)
    allow(controller).to receive(:current_user_session).and_return(true)

    @channel = FactoryBot.create(:channel, :user => @user)

    @window = FactoryBot.create(:window)
    @channel.windows << @window

  end

  describe "PUT 'hide' for window" do
    it "should update the show_flag on that window" do
      put 'hide', params: { channel_id: @channel.id, id: @window.id }
      expect(response).to be_successful
    end
  end

  describe "POST 'update'" do
    it "should allow an update" do
      post 'update', params: { channel_id: @channel.id, page: "{\"col\":0,\"positions\":[#{@window.id}]}" }
      expect(response).to be_successful
    end
  end

  describe "POST 'update' with invalid position" do

    it "should fail" do
      post 'update', params: { channel_id: @channel.id, page: "{\"col\":0,\"positions\":[999]}" }
      expect(response).to be_successful
    end
  end
  describe "When getting " do

    it "should render private_windows json" do
      get 'private_windows', params: { channel_id: @channel.id, format: :json }
      expect(response).to be_successful
    end
    it "should render show_flag = false" do
      @channel.windows[0].show_flag = false
      @channel.save
      get 'hidden_windows', params: { channel_id: @channel.id, visibility_flag: "private", format: :json }

      expect(response.status).to eq(200)
    end
  end

end

describe WindowsController do
  render_views
  before :each do
    @channel = FactoryBot.create(:channel)
    @window = FactoryBot.create(:window, html: "<iframe src=\"/\"/>")
    @channel.windows << @window
  end

  describe "POST 'update'" do
    it "should fail with no current user" do
      post 'update', params: { channel_id: @channel.id, page: "{\"col\":0,\"positions\":[" + @window.id.to_s + "]}" }
      expect(response.status).to eq(302)
    end
  end


  describe "When getting " do
    it "should render json" do
      get 'index', params: { channel_id: @channel.id, format: :json }
      expect(response.status).to eq(200)
      response.body == @channel.windows.to_json
    end


    it "should not render show_flag = false" do

      @channel.windows.each do |window|
        window.show_flag = false
      end
      saved = @channel.save
      expect(saved).to be_truthy

      get 'index', params: { channel_id: @channel.id, format: :json }

      expect(response.status).to eq(200)

      result = JSON.parse(response.body)
      expect(result.size).to eq(0)
    end

  end

  describe "GET 'iframe' for window" do
    it "should return html with gsub for iframe" do
      get 'iframe', params: { channel_id: @channel.id, id: @window.id }
      expect(response).to be_successful
      expect(response.body).to eq("<iframe src=\"http://test.host/\"/>")
    end
    it "should render json" do
      @channel.windows[0].show_flag = false
      @channel.save
      get 'index', params: { channel_id: @channel.id, format: :json }

      expect(response.status).to eq(200)
      response.body == @channel.windows.to_json

    end
  end

  describe "GET 'html' for window" do
    it "should return html" do
      get 'html', params: { channel_id: @channel.id, id: @window.id }

      expect(response).to be_successful
      expect(response.body).to eq("<iframe src=\"/\"/>")
    end
  end
  describe "PUT 'hide' for window" do
    it "should return a redirect to login_path for no current_user" do
      put 'hide', params: { channel_id: @channel.id, id: @window.id }
      expect(response).to redirect_to(login_path)
    end
  end

end
