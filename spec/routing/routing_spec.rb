require "spec_helper"

describe "routes for Widgets" do
  it "routes / to the pages controller" do
    expect({ :get => "/" }).to route_to(:controller => "pages", :action => "home")
  end
  it "routes /channels/:id to the channels controller" do
    expect({ :get => "/channels/1" }).to route_to(:controller => "channels", :action => "show", :id => "1")
  end
end
