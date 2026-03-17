# == Schema Information
#
# Table name: windows
#
#  id           :integer          not null, primary key
#  channel_id   :integer
#  position     :integer
#  created_at   :datetime
#  updated_at   :datetime
#  html         :text
#  col          :integer
#  title        :string(255)
#  window_type  :string(255)
#  name         :string(255)
#  private_flag :boolean          default(FALSE)
#  show_flag    :boolean          default(TRUE)
#  content_id   :integer
#  options      :text
#

require 'spec_helper'

describe Window do
  it "should be valid" do
    channel = FactoryBot.create(:channel)
    window = Window.new(channel: channel)
    expect(window).to be_valid
  end
end
