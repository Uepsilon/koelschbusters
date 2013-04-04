class User < ActiveRecord::Base
  # possible roles
  ROLES   = %w[member management admin]

  has_many :posts

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable,
         :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :first_name, :last_name, :role, :phone, :mobile,
                  :member_active, :address, :houseno, :zipcode, :city,
                  :email_confirmation, :current_password

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

  protected

  def random_password
    # TODO: This does not look random at all ;)
    self.password = 'Test1234' if self.password.blank?
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
