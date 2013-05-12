class User < ActiveRecord::Base
  # possible roles
  ROLES   = %w[member management admin]

  has_many :news

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable,
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

  attr_accessor   :email_confirmation

  before_validation :random_password, :on => :create
  before_validation :email_downcase
  before_validation :stringify_role
  after_create      :wipe_virtual_password

  validates :email,         :presence => true,      :uniqueness => true
  validates :email,         :confirmation => true , :if => :email_confirmation?
  validates :email_confirmation, :presence => true, :on => :update, :if => :email_confirmation?

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
    self.send("#{provider}_name=", provider == :twiter ? auth.info.nickname : auth.info.name)

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
    self.password = Devise.friendly_token[0,20] if self.password.nil?
  end

  def password_changed?
    not self.password.nil?
  end

  def email_confirmation?
    self.email_changed?
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
end
