# == Schema Information
#
# Table name: templates
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  content    :text
#  site_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Template < ActiveRecord::Base
  belongs_to :site
end
