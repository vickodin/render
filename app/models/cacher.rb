# == Schema Information
#
# Table name: cachers
#
#  id         :integer          not null, primary key
#  page_id    :integer
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Cacher < ActiveRecord::Base
  belongs_to :page
end
