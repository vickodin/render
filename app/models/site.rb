# == Schema Information
#
# Table name: sites
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  user_id     :integer
#  domain_id   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  own_domain  :string(255)      default(""), not null
#  more        :text
#  compress    :boolean          default(TRUE)
#  modified_at :datetime         default(2013-09-30 06:36:37 UTC), not null
#  public      :boolean          default(FALSE), not null
#

class Site < ActiveRecord::Base
  belongs_to :user
  belongs_to :domain

  has_many :stylesheets
  has_many :javascripts
  has_many :pages
  has_many :templates
  has_many :layouts
  has_many :images
  has_many :documents

  has_and_belongs_to_many :forms, :conditions => proc { "forms.user_id = #{self.user_id}" }, uniq: true

  def full_name
    if self.own_domain.blank?
      self.name + '.' + self.domain.name
    else
      self.own_domain
    end
  end

  def full_url
    "http://#{self.full_name}"
  end
end
