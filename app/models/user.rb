class User < ActiveRecord::Base
  # possible roles
  ROLES   = %w[member management admin]

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
                  :address, :houseno, :zipcode, :city,
                  :google_uid, :google_name,
                  :twitter_uid, :twitter_name,
                  :facebook_uid, :facebook_name

  attr_accessor   :email_confirmation

  before_validation :random_password, :on => :create
  before_validation :email_downcase

  validates :email,         :presence => true,      :uniqueness => true
  validates :email,         :confirmation => true,  :if => :email_confirmation?

  validates :password,      :presence => true,      :on => :create
  validates :password,      :confirmation => true,  :on => :update, :if => :change_password?

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
      ROLES.index(base_role.to_s) <= ROLES.index(role)
  end

  def self.find_or_update_by_oauth(auth, provider, signed_in_resource=nil)
    user = nil

    # check if user already logged in
    unless signed_in_resource.nil?
      user = User.find signed_in_resource.id

      # set google uid and name to current user if not already set
      if user.send("#{provider}_uid").nil?
        user.send("#{provider}_uid=", auth.uid)
        case provider
        when :twitter
          user.send("#{provider}_name=", auth.info.nickname)
        else
          user.send("#{provider}_name=", auth.info.name)
        end

        # update user
        user.save!

        return user
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

  def remove_oauth(provider)
    unless self.send("#{provider}_uid").nil?
      self.send("#{provider}_uid=", nil)
      self.send("#{provider}_name=", nil)
    end

    return self.save if self.changed?
  end

  protected

  def random_password
    # Create random password if password not set
    self.password = Devise.friendly_token[0,20] if self.password.nil?
  end

  def change_password?
    not self.password.blank?
  end

  def email_confirmation?
    not email_confirmation.blank? or self.email_changed?
  end

  def email_downcase
    self.email               = self.email.downcase
    self.email_confirmation  = self.email_confirmation.downcase unless email_confirmation.nil?
  end
end
