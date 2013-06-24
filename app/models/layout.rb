# == Schema Information
#
# Table name: layouts
#
#  id         :integer          not null, primary key
#  name       :string(255)      default(""), not null
#  content    :text
#  site_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Layout < ActiveRecord::Base
  belongs_to :site
end
