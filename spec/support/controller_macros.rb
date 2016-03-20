module ControllerMacros
  def login_admin(admin = nil)
    @request.env['devise.mapping'] = Devise.mappings[:admin]
    @current_user = admin
    @current_user = FactoryGirl.create(:user, :admin) if @current_user.nil? || !@current_user.is_a?(User)
    sign_in @current_user
  end

  def login_manager(manager = nil)
    @request.env['devise.mapping'] = Devise.mappings[:manager]
    @current_user = manager
    @current_user = FactoryGirl.create(:user, :management) if @current_user.nil? || !@current_user.is_a?(User)
    sign_in @current_user
  end

  def login_user(user = nil)
    @request.env['devise.mapping'] = Devise.mappings[:user]
    @current_user = user
    @current_user = FactoryGirl.create(:user) if @current_user.nil? || !@current_user.is_a?(User)
    sign_in @current_user
  end
end
