# == Schema Information
#
# Table name: images
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  photo      :string(255)
#  site_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Image < ActiveRecord::Base
  belongs_to :site
  attr_accessible :name, :photo
  
  mount_uploader :photo, ImageUploader

  def full_url
    if self.photo_url
      return "#{site.full_url}/#{self.photo.url}"
    else
      return nil
    end
  end
end
