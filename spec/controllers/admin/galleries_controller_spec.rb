require 'spec_helper'

describe Admin::GalleriesController do
  context "when authorized user is logged in" do
    before(:each) { login_manager }

    describe "GET #index" do
      let(:gallery)               { create(:gallery) }
      let(:gallery_with_pictures) { create(:gallery_with_pictures) }
      before(:each)               { get :index }

      subject { assigns(:galleries) }

      it { response.response_code.should eq(200) }
      it { subject.should include gallery }
      it { subject.should include gallery_with_pictures }
    end
  end
end
