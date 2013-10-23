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

  has_many :stylesheets,  :dependent => :destroy
  has_many :javascripts,  :dependent => :destroy
  has_many :pages,        :dependent => :destroy
  has_many :templates,    :dependent => :destroy
  has_many :layouts,      :dependent => :destroy
end
