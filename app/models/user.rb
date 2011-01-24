# == Schema Information
# Schema version: 20110114091806
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#
require 'digest'
class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation

  has_many :microposts, :dependent => :destroy
  has_many :relationships, :foreign_key => "follower_id",  #destroying a user should also destroy that user’s relationships
                           :dependent => :destroy
  has_many :following, :through => :relationships, :source => :followed #:source parameter which explicitly tells Rails that the source of the following array is the set of followed ids.

  has_many :reverse_relationships, :foreign_key => "followed_id",
                                   :class_name => "Relationship",
                                   :dependent => :destroy
  has_many :followers, :through => :reverse_relationships, :source => :follower


  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, :presence => true, # Must have name
                     :length   => { :maximum => 50 } #Length
  validates :email, :presence => true, # Must have password
                     :format   => { :with => email_regex }, #Format above
                     :uniqueness =>  { :case_sensitive => false } # Check for non case sensitive and uniqueness

  # Automatically create the virtual attribute 'password_confirmation'.

  validates :password, :presence     => true,
                       :confirmation => true, #Double confirmation of password and password confirmation
                       :length       => { :within => 6..40 } # length within 6 to 40

  before_save :encrypt_password # encrypt password before saving

  def has_password?(submitted_password) #Check the user has password
    encrypted_password == encrypt(submitted_password) # encrypt password
  end

  def self.authenticate(email, submitted_password) # authenticate the password when user login
    user = find_by_email(email)
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
  end

   def self.authenticate_with_salt(id, cookie_salt) #authenticate with the salt for remember me
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end

  def following?(followed)
    relationships.find_by_followed_id(followed)
  end

  def follow!(followed)
    relationships.create!(:followed_id => followed.id)
  end

  def unfollow!(followed)
    relationships.find_by_followed_id(followed).destroy
  end

  def feed
    # This is preliminary. See Chapter 12 for the full implementation.
    Micropost.where("user_id = ?", id) #The question mark ensures that id is properly escaped before being included in the underlying SQL query, thereby avoiding a serious security hole called SQL injection. (The id attribute here is just an integer, so there is no danger in this case, but always escaping variables injected into SQL statements is a good habit to cultivate.)
  end

  private
    def encrypt_password #encrypt password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end

    def encrypt(string) # encrypt the password with salt
      secure_hash("#{salt}--#{string}")
    end

    def make_salt # create salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string) # Create Hash password
      Digest::SHA2.hexdigest(string)
    end

end
