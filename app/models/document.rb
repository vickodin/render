# == Schema Information
#
# Table name: documents
#
#  id         :integer          not null, primary key
#  site_id    :integer
#  name       :string(255)
#  attachment :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Document < ActiveRecord::Base
  belongs_to :site

  mount_uploader :attachment, DiskUploader

  def full_url
    if self.attachment?
      return "#{site.full_url}/#{self.attachment.path}"
    else
      return nil
    end
  end
end
