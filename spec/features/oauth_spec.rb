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

        page.first(".twitter-login").click

        page.should have_content('Abmelden')
        page.should have_content('erfolgreich')
        page.should have_content('Twitter')
       end

      it "does not log in when user not found" do
        create(:user, twitter_uid: 123456)

        visit "/login"

        page.first(".twitter-login").click

        page.should have_content('Anmelden')
        page.should have_content('nicht eingeloggt')
       end
     end

     context "when facebook is used" do
      it "logs in user when found" do
        create(:user, facebook_uid: 12345)

        visit "/login"

        page.first(".facebook-login").click

        page.should have_content('Abmelden')
        page.should have_content('eingeloggt')
        page.should have_content('Facebook')
       end

      it "does not log in when user not found" do
        create(:user, facebook_uid: 123456)

        visit "/login"

        page.first(".facebook-login").click

        page.should have_content('Anmelden')
        page.should have_content('nicht eingeloggt')
       end
    end

     context "when google is used" do
      it "logs in user when found" do
        create(:user, google_uid: 12345)

        visit "/login"

        page.first(".google_oauth2-login").click

        page.should have_content('Abmelden')
        page.should have_content('eingeloggt')
        page.should have_content('Google')
       end

      it "does not log in when user not found" do
        create(:user, google_uid: 123456)

        visit "/login"

        page.first(".google_oauth2-login").click

        page.should have_content('Anmelden')
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

        page.first('.twitter-link').click

        page.should have_content('TestUser')
       end

       it "removes twitter from account" do
          login_as(user_twitter, scope: :user)

          visit "/profil"

          page.should have_content('TestUser')

          page.first('.twitter-unlink').click

          page.should have_content('Mit Twitter verknüpfen')
       end
     end

     context "when facebook is used" do
      it "connects facebook to account" do
        login_as(user, scope: :user)

        visit "/profil"

        page.first('.facebook-link').click

        page.should have_content('TestUser')
       end

       it "removes facebook from account" do
          login_as(user_facebook, scope: :user)

          visit "/profil"

          page.should have_content('TestUser')

          page.first('.facebook-unlink').click

          page.should have_content('Mit Facebook verknüpfen')
       end
     end

     context "when google is used" do
      it "connects google to account" do
        login_as(user, scope: :user)

        visit "/profil"

        page.first('.google_oauth2-link').click

        page.should have_content('TestUser')
       end

       it "removes google from account" do
          login_as(user_google, scope: :user)

          visit "/profil"

          page.should have_content('TestUser')

          page.first('.google_oauth2-unlink').click

          page.should have_content('Mit Google verknüpfen')
       end
    end
  end
end