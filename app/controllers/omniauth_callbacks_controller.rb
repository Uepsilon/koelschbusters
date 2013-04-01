class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def google_oauth2
    process_auth_result(:google)
  end

  def twitter
    process_auth_result(:twitter)
  end

  def facebook
    process_auth_result(:facebook)
  end

  protected

  def process_auth_result(provider)
    @user = User.find_or_update_by_oauth(request.env["omniauth.auth"], provider, current_user)

    Rails.logger.debug request.env['omniauth.auth'].inspect

    provider_name = provider.to_s.capitalize

    if user_signed_in?
      unless @user.nil?
        flash[:notice] = "Dein #{provider_name}-Account wurde erfolgreich mit deinem Kölschbusters-Account verbunden."
      else
        flash[:alert] = "Dein #{provider_name}-Account konnte nicht verbunden werden. Solltest du schon einen #{provider_name}-Account verbunden haben, entferne diesen bitte zuerst"
      end

      redirect_to :user
    else
      unless @user.nil?
        flash[:notice] = "Du wurdest erfolgreich über #{provider_name} eingeloggt."
        sign_in_and_redirect @user, :event => :authentication
      else
        flash[:alert] = "Du konntest leider nicht eingeloggt werden."
        redirect_to new_user_session_url
      end
    end
  end
end
