# == Schema Information
#
# Table name: javascripts
#
#  id         :integer          not null, primary key
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  site_id    :integer
#  name       :string(255)      default(""), not null
#

class Javascript < ActiveRecord::Base
  include Mincer

  belongs_to :site
  has_one :cacher, as: :cacheable
end
