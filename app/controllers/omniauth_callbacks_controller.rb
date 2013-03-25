class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def google_oauth2
      @user = User.find_for_google_oauth2(request.env["omniauth.auth"], current_user)

      unless @user.nil?
        flash[:notice] = "Du wurdest erfolgreich über Google eingeloggt."
        sign_in_and_redirect @user, :event => :authentication
      else
        flash[:alert] = "Du konntest leider nicht eingeloggt werden."
        redirect_to new_user_session_url
      end
  end
end
