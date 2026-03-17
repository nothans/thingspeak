require 'spec_helper'

describe ChartsController do
  render_views
  before :each do
    @user = FactoryBot.create(:user)

    allow(controller).to receive(:current_user).and_return(@user)
    allow(controller).to receive(:current_user_session).and_return(true)
    @channel = FactoryBot.create(:channel, :user => @user)



  end

  describe "responding to a GET index" do
    it "has a 'select' selector for 'dynamic'" do
      get :index, params: { channel_id: @channel.id }
      expect(response).to be_successful
      expect(response).to have_selector("select#dynamic_0")
    end
  end

end
