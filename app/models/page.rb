# == Schema Information
#
# Table name: pages
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  site_id    :integer
#  content    :text
#  system     :boolean          default(FALSE), not null
#  kind       :string(255)      default("html"), not null
#

class Page < ActiveRecord::Base
  include Mincer

  belongs_to :site
  has_one :cacher, as: :cacheable

end
