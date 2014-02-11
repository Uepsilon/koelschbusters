module ControllerMacros
  def login_admin(admin=nil)
    @request.env["devise.mapping"] = Devise.mappings[:admin]
    if admin.nil? or not admin.is_a? User
      sign_in FactoryGirl.create(:user, :admin) # Using factory girl as an example
    else
      sign_in admin
    end
  end

  def login_manager(manager=nil)
    @request.env["devise.mapping"] = Devise.mappings[:manager]
    if manager.nil? or not manager.is_a? User
      sign_in FactoryGirl.create(:user, :management)
    else
      sign_in manager
    end
  end

  def login_user(user=nil)
    @request.env["devise.mapping"] = Devise.mappings[:user]
    if user.nil? or not user.is_a? User
      sign_in FactoryGirl.create(:user)
    else
      sign_in user
    end
  end
end