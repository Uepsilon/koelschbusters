# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  first_name             :string(255)      default(""), not null
#  last_name              :string(255)      default(""), not null
#  street                 :string(255)
#  houseno                :string(255)
#  zipcode                :string(255)
#  city                   :string(255)
#  phone                  :string(255)
#  mobile                 :string(255)
#  member_active          :boolean          default(FALSE)
#  role                   :string(255)      default("member"), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  twitter_uid            :string(255)
#  twitter_name           :string(255)
#  facebook_uid           :string(255)
#  facebook_name          :string(255)
#  google_uid             :string(255)
#  google_name            :string(255)
#

class User < ActiveRecord::Base
  # possible roles
  ROLES   = %w[guest member management admin]
  PROVIDER = {
    google_oauth2:  :google,
    twitter:        :twitter,
    facebook:       :facebook
  }

  has_many :news
  has_many :comments

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :confirmable,
         :trackable, :validatable, :omniauthable, :omniauth_providers => [:google_oauth2, :twitter, :facebook]

  attr_accessible :email, :email_confirmation,
                  :password, :password_confirmation, :current_password,
                  :remember_me,
                  :first_name, :last_name,
                  :role,
                  :phone, :mobile,
                  :member_active,
                  :street, :houseno, :zipcode, :city,
                  :google_uid, :google_name,
                  :twitter_uid, :twitter_name,
                  :facebook_uid, :facebook_name

  attr_accessor :email_confirmation
  attr_accessor :uncrypt_password

  before_validation :random_password, :on => :create
  before_validation :email_downcase
  before_validation :stringify_role
  after_create      :wipe_virtual_password

  validates :email,         :presence => true,      :uniqueness => true
  validates :email,         :confirmation => true, :if => :email_confirmation?

  validates :password,      :presence => true,     :on => :create
  validates :password,      :confirmation => true, :on => :update, :if => :password_changed?
  validates :password_confirmation, :presence => true,  :on => :update, :if => :password_changed?

  validates :first_name,    :presence => true
  validates :last_name,     :presence => true

  validates :phone,         :numericality => {:only_integer => true}, :allow_nil => true, :allow_blank => true
  validates :mobile,        :numericality => {:only_integer => true}, :allow_nil => true, :allow_blank => true

  validates :zipcode,       :length =>  {:is => 5}, :numericality => {:only_integer => true}, :allow_nil => true, :allow_blank => true
  validates :role,          :inclusion => {:in => ROLES}

  def name
    "#{first_name} #{last_name}"
  end

  def active?
    member_active
  end

  def role?(base_role)
      (ROLES.index(base_role.to_s) <= ROLES.index(role)) and active?
  end

  def self.find_by_oauth(auth, provider)
    User.where("#{provider}_uid" => auth.uid).first
  end

  def add_oauth(auth, provider)
    self.send("#{provider}_uid=", auth.uid)
    self.send("#{provider}_name=", provider == :twitter ? auth.info.nickname : auth.info.name)

    self.save
  end

  def remove_oauth(provider)
    unless self.send("#{provider}_uid").nil?
      self.send("#{provider}_uid=", nil)
      self.send("#{provider}_name=", nil)
    end

    return self.save if self.changed?
  end

  def address?
    (street.present? and houseno.present?) and (city.present? or zipcode.present?)
  end

  protected

  def random_password
    # Create random password if password not set
    if self.password.nil?
      self.uncrypt_password = Devise.friendly_token[0,20]
      self.password = self.uncrypt_password
    end
  end

  def email_confirmation?
    self.email_changed?
  end

  def password_changed?
    not self.password.nil?
  end

  def email_downcase
    self.email               = self.email.downcase
    self.email_confirmation  = self.email_confirmation.downcase unless email_confirmation.nil?
  end

  def wipe_virtual_password
    #  must wipe password after create so password change is detectable
    self.password = nil
  end

  def stringify_role
    role = role.to_s
  end

  # welcome email
  def send_on_create_confirmation_instructions
    ContactMailer.welcome_instructions(self, @raw_confirmation_token).deliver
  end
end
