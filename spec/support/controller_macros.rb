module ControllerMacros
  def login_admin
    @request.env["devise.mapping"] = Devise.mappings[:admin]
    sign_in FactoryGirl.create(:user, :admin) # Using factory girl as an example
  end

  def login_manager
    @request.env["devise.mapping"] = Devise.mappings[:manager]
    sign_in FactoryGirl.create(:user, :manager)
  end

  def login_user
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in FactoryGirl.create(:user)
  end
end