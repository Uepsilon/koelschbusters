require "spec_helper"

# include waren to log in user
include Warden::Test::Helpers
Warden.test_mode!

describe "Oauth Feature" do
  context "when user is not logged in" do
    context "when twitter is used" do

      it "logs in user when found" do
        create(:user, twitter_uid: 12345)

        visit "/login"

        click_link "Sign in with Twitter"

        page.should have_content('Logout')
        page.should have_content('erfolgreich')
        page.should have_content('Twitter')
       end

      it "does not log in when user not found" do
        create(:user, twitter_uid: 123456)

        visit "/login"

        click_link "Sign in with Twitter"

        page.should have_content('Login')
        page.should have_content('nicht eingeloggt')
       end
     end

     context "when facebook is used" do
      it "logs in user when found" do
        create(:user, facebook_uid: 12345)

        visit "/login"

        click_link "Sign in with Facebook"

        page.should have_content('Logout')
        page.should have_content('eingeloggt')
        page.should have_content('Facebook')
       end

      it "does not log in when user not found" do
        create(:user, facebook_uid: 123456)

        visit "/login"

        click_link "Sign in with Facebook"

        page.should have_content('Login')
        page.should have_content('nicht eingeloggt')
       end
    end

     context "when google is used" do
      it "logs in user when found" do
        create(:user, google_uid: 12345)

        visit "/login"

        click_link "Sign in with Google"

        page.should have_content('Logout')
        page.should have_content('eingeloggt')
        page.should have_content('Google')
       end

      it "does not log in when user not found" do
        create(:user, google_uid: 123456)

        visit "/login"

        click_link "Sign in with Google"

        page.should have_content('Login')
        page.should have_content('nicht eingeloggt')
       end
    end
  end


  context "when user is logged in" do
    let(:user)          { create :user }
    let(:user_twitter)  { create :user, twitter_uid: 12345, twitter_name: "TestUser" }
    let(:user_facebook) { create :user, facebook_uid: 12345, facebook_name: "TestUser" }
    let(:user_google)   { create :user, google_uid: 12345, google_name: "TestUser" }

    context "when twitter is used" do
      it "connects twitter to account" do
        login_as(user, scope: :user)

        visit "/profil"

        click_link "Twitter"

        page.should have_content('Twitter: TestUser')
       end

       it "removes twitter from account" do
          login_as(user_twitter, scope: :user)

          visit "/profil"

          page.should have_content('Twitter: TestUser')

          click_link "Entfernen"

          page.should have_content('Mit Twitter verknüpfen')
       end
     end

     context "when facebook is used" do
      it "connects facebook to account" do
        login_as(user, scope: :user)

        visit "/profil"

        click_link "Facebook"

        page.should have_content('Facebook: TestUser')
       end

       it "removes facebook from account" do
          login_as(user_facebook, scope: :user)

          visit "/profil"

          page.should have_content('Facebook: TestUser')

          click_link "Entfernen"

          page.should have_content('Mit Facebook verknüpfen')
       end
     end

     context "when google is used" do
      it "connects google to account" do
        login_as(user, scope: :user)

        visit "/profil"

        click_link "Google"

        page.should have_content('Google: TestUser')
       end

       it "removes google from account" do
          login_as(user_google, scope: :user)

          visit "/profil"

          page.should have_content('Google: TestUser')

          click_link "Entfernen"

          page.should have_content('Mit Google verknüpfen')
       end
    end
  end
end