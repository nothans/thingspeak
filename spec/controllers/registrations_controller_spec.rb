require 'spec_helper'

describe RegistrationsController do
  render_views

  describe "new account" do

    it "should create a new user if user parameters are complete" do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      post :create, params: { user: {"login"=>"xxx", "email"=>"xxx@insomnia-consulting.org", "time_zone"=>"Eastern Time (US & Canada)", "password"=>"[FILTERED]", "password_confirmation"=>"[FILTERED]"} }
      expect(response.code).to eq("302")
      expect(response).to redirect_to(channels_path)
    end

    it "should have a valid api_key" do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      post :create, params: { user: {"login"=>"xxx", "email"=>"xxx@insomnia-consulting.org", "password"=>"[FILTERED]", "password_confirmation"=>"[FILTERED]"} }
      expect(assigns[:user].api_key.length).to eq(16)
    end

  end

end
