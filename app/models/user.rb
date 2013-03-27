class User < ActiveRecord::Base
  # possible roles
  ROLES   = %w[member management admin]

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable,
         :trackable, :validatable, :omniauthable, :omniauth_providers => [:google_oauth2, :twitter, :facebook]

  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :first_name, :last_name, :role, :phone, :mobile,
                  :member_active, :address, :houseno, :zipcode, :city

  before_validation :random_password, :on => :create

  validates :email,                  :presence => true,  :uniqueness => true, :on => :create
  validates :password,               :confirmation => true
  validates :password_confirmation,  :presence => true, :on => :create
  validates :first_name,             :presence => true
  validates :last_name,              :presence => true
  validates :phone,                  :numericality => {:only_integer => true}, :allow_nil => true, :allow_blank => true
  validates :mobile,                 :numericality => {:only_integer => true}, :allow_nil => true, :allow_blank => true

  validates :zipcode,                :length =>  {:is => 5}, :numericality => {:only_integer => true},
                                     :allow_nil => true, :allow_blank => true

  validates :role,                   :inclusion => {:in => ROLES}

  def name
    "#{first_name} #{last_name}"
  end

  def active?
    member_active
  end

  def role?(base_role)
      ROLES.index(base_role.to_s) <= ROLES.index(role)
  end

  def self.find_or_update_by_oauth(auth, provider, signed_in_resource=nil)
    user = nil

    # check if user already logged in
    unless signed_in_resource.nil?
      # set google uid and name to current user if not already set
      if signed_in_resource.send("#{provider}_uid").nil?
        signed_in_resource.send("#{provider}_uid=", auth.uid)
        signed_in_resource.send("#{provider}_name=", auth.info.name)

        return signed_in_resource
      else
        return nil
      end
    else
      case provider
      when :twitter
        user = User.where(:twitter_uid => auth.uid).first
      when :google
        user = User.where(:google_uid => auth.uid).first
      when :facebook
        user = User.where(:facebook_uid => auth.uid).first
      else
        return nil
      end
    end

    user
  end

  protected

  def random_password
    # Create random password if password not set
    self.password = Devise.friendly_token[0,20] if self.password.nil?
  end
end
