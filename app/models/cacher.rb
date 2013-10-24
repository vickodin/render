# == Schema Information
#
# Table name: cachers
#
#  id             :integer          not null, primary key
#  content        :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  cacheable_type :string(255)      default("Page"), not null
#  cacheable_id   :integer
#

class Cacher < ActiveRecord::Base
  belongs_to :cacheable, polymorphic: true
end
