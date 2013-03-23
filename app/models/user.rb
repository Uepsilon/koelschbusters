class User < ActiveRecord::Base
  # possible roles
  ROLES   = %w[member management admin]

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable,
         :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :first_name, :last_name, :role, :phone, :mobile,
                  :member_active, :address, :houseno, :zipcode, :city

  before_validation :random_password

  validate :email,        :presence => true,  :uniqueness => true
  validate :password,     :confirmation => true
  validate :password_confirmation,   :presence => true

  validate :first_name,   :presence => true
  validate :last_name,    :presence => true

  validate :phone,        :numericality => true
  validate :mobile,       :numericality => true

  validate :address
  validate :houseno

  validate :zipcode,      :length =>  { :is => 5}
  validate :city

  validate :member_active,:presence => true
  validate :role,         :presence => true, :inclusion => { :in => ROLES }

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
    self.password = 'Test1234'
  end
end
