# == Schema Information
#
# Table name: headers
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  value        :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  thinghttp_id :integer
#

class Header < ApplicationRecord
  belongs_to :thinghttp
end

