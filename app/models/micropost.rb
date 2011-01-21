class Micropost < ActiveRecord::Base
  attr_accessible :content # Since user_id isn’t listed as an attr_accessible parameter, it can’t be edited through the web and is necessary for site security
  belongs_to :user

  validates :content, :presence => true, :length => { :maximum => 140 }
  validates :user_id, :presence => true

  default_scope :order => 'microposts.created_at DESC' # The order of the microposts
end
