require 'spec_helper'

describe GalleriesController do
  after(:all) { Gallery.destroy_all }
  after(:all) { Picture.destroy_all }

  let!(:gallery_with_pictures) { create :gallery_with_pictures }
  let!(:gallery_with_internal_pictures) { create :gallery_with_internal_pictures }

  context "when user is logged in" do
    before { login_user }

    describe "GET #index" do
      before { get :index }
      subject { assigns(:galleries) }

      it { response.status.should eq 200 }
      it { subject.should include gallery_with_pictures }
      it { subject.should include gallery_with_internal_pictures }
    end

    describe "GET #show" do
      before { get :show, id: gallery_with_pictures.to_param }
      subject { assigns(:pictures) }

      it { response.status.should eq 200 }
      it { subject.should match_array(gallery_with_pictures.pictures) }
    end
  end

  context "when user is not logged in" do
    describe "GET #index" do
      before { get :index }
      subject { assigns(:galleries) }

      it { response.status.should eq 200 }
      it { subject.should include gallery_with_pictures }
      it { subject.should_not include gallery_with_internal_pictures }
    end
  end

    describe "GET #show for an gallery with public pictures" do
      before { get :show, id: gallery_with_pictures.to_param }
      subject { assigns(:pictures) }

      it { response.status.should eq 200 }

      it "assigns public pictures" do
        gallery_with_pictures.public_pictures do |picture|
          subject.should include picture
        end
      end

      it "does not assigns internal pictures" do
        gallery_with_pictures.internal_pictures do |picture|
          subject.should_not include picture
        end
      end
    end

    describe "GET #show for an gallery with internal pictures" do
      before { get :show, id: gallery_with_internal_pictures.to_param }
      subject { assigns(:pictures) }

      it { response.status.should eq 401 }
      it { subject.should be_nil }
    end
end
