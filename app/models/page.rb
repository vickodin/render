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
  KIND   = ['html', 'txt']

  attr_accessible :content, :name, :kind
  belongs_to :site
  validates :name, :uniqueness => {:scope => [:site_id, :kind]}
  validates :name, :presence => true
  validates :name, :format => {:with => /\A[^~`@#\$%^&*()\[\]{}+=|\\:;"'<>,.]+\z/}
  validates :kind, :inclusion => { :in => Page::KIND}

  KIND   = [:html, :txt]
  extend Enumerize
  enumerize :kind, :in => Page::KIND, :predicates => true

  def full_name
    path = '/'
    unless self.name == '/'
      path = "/#{self.name}"
      unless self.html?
        path +='.'+self.kind
      end
    end
    return path
  end

  def public_name
    if self.system && self.name == '/'
      return 'Index page'
    else
      unless self.html?
        return "#{self.name}.#{self.kind}"
      else
        return self.name
      end
    end
  end
  
  def short_public_name
    self.public_name.truncate(30)
  end
  def full_url
    "#{self.site.full_url}#{self.full_name}"
  end
end
