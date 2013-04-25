require "spec_helper"

describe "Oauth Feature" do
  context "when user is not logged in" do
    context "when twitter is used" do
      # let!(:user) { create(:user, twitter_uid: 12345) }

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
end