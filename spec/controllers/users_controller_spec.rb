require 'spec_helper'

describe UsersController do
  render_views
  before :each do
    @user = FactoryBot.create(:user)
  end

  describe "api" do

    it "should show login in public json info" do
      get :profile, params: { glob: @user.login, format: 'json' }
      expect(JSON.parse(response.body)['login']).to eq(@user.login)
    end

    it "should not show email in public json info" do
      get :profile, params: { glob: @user.login, format: 'json' }
      expect(JSON.parse(response.body)['email']).to eq(nil)
    end

    it "should show email in private json info" do
      get :profile, params: { glob: @user.login, format: 'json', key: @user.api_key }
      expect(JSON.parse(response.body)['email']).to eq(@user.email)
    end
  end

  describe "login via api" do
    it "should return a token" do
      post :api_login, params: { login: @user.login, password: @user.password }
      @user.reload
      expect(response.body).to eq(@user.authentication_token)
    end

    it "returns JSON" do
      post :api_login, params: { login: @user.login, password: @user.password, format: 'json' }
      @user.reload
      expect(JSON.parse(response.body)['login']).to eq(@user.login)
      expect(JSON.parse(response.body)['authentication_token']).to eq(@user.authentication_token)
    end

    it "returns XML" do
      post :api_login, params: { login: @user.login, password: @user.password, format: 'xml' }
      @user.reload
      expect(Nokogiri::XML(response.body).css('login').text).to eq(@user.login)
      expect(Nokogiri::XML(response.body).css('authentication-token').text).to eq(@user.authentication_token)
    end
  end

  describe "authentication via api" do
    it "should not allow authentication via incorrect token" do
      # attempt to get private profile info
      get :profile, params: { glob: @user.login, format: 'json', login: @user.login, token: 'bad token' }
      expect(JSON.parse(response.body)['email']).to eq(nil)
    end

    it "should allow authentication via correct token" do
      # attempt to get private profile info
      get :profile, params: { glob: @user.login, format: 'json', login: @user.login, token: @user.authentication_token }
      expect(JSON.parse(response.body)['email']).to eq(@user.email)
    end
  end

end
