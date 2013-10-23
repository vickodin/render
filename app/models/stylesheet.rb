# == Schema Information
#
# Table name: stylesheets
#
#  id         :integer          not null, primary key
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  site_id    :integer
#  name       :string(255)      default(""), not null
#

class Stylesheet < ActiveRecord::Base
  belongs_to :site
end
