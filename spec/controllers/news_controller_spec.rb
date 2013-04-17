require 'spec_helper'

describe NewsController do
  describe 'GET #index' do
    let!(:regular_news) { create(:news) }
    let!(:private_news) { create(:news, :members_only) }
    let!(:unpublished_news) { create(:news, :unpublished) }
    let!(:upcoming_news) { create(:news, :upcoming) }

    context "when user is logged in" do
      before(:each) { login_user }
      before(:each) { get :index }

      subject { assigns(:news) }

      it { response.should be_success }
      it { should include(regular_news)}
      it { should include(private_news) }
      it { should_not include(unpublished_news) }
      it { should_not include(upcoming_news) }
    end

    context "when user is not logged in" do
      before(:each) { get :index }

      subject { assigns(:news) }

      it { response.should be_success }
      it { should include(regular_news) }
      it { should_not include(private_news) }
      it { should_not include(unpublished_news) }
      it { should_not include(upcoming_news) }
    end
  end
end
