# == Schema Information
#
# Table name: forms
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  name       :string(255)
#  uuid       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  redirect   :string(255)
#

class Form < ActiveRecord::Base
  belongs_to :user
  has_many :fields
  has_many :submits
end
