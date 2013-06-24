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
#  slug       :string(255)
#

class Page < ActiveRecord::Base
  belongs_to :site
end
