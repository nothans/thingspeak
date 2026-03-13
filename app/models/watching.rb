# == Schema Information
#
# Table name: watchings
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  channel_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class Watching < ApplicationRecord
  belongs_to :user
  belongs_to :channel

  # check if the channel is being watched by this user
  def self.check(user_id, channel_id)
    @watching = Watching.find_by(user_id: user_id, channel_id: channel_id)
    !@watching.nil?
  end

end
