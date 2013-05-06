require 'spec_helper'

describe Admin::PicturesController do
  context "when user not logged in" do
    let(:picture) { create :picture }

    describe "GET #index" do
      it_should_behave_like "has to be logged in" do
        before { get :index, gallery_id: picture.gallery_id }
      end
    end

    describe "GET #new" do
      it_should_behave_like "has to be logged in" do
        before { get :new, gallery_id: picture.gallery_id }
      end
    end

    describe "POST #create" do
      it_should_behave_like "has to be logged in" do
        before { post :create, picture: attributes_for(:picture), gallery_id: picture.gallery_id }
      end
    end

    describe "GET #edit" do
      it_should_behave_like "has to be logged in" do
        before { get :edit, id: picture.to_param, gallery_id: picture.gallery_id }
      end
    end

    describe "PUT #update" do
      it_should_behave_like "has to be logged in" do
        before { put :update, id: picture.to_param, picture: attributes_for(:picture), gallery_id: picture.gallery_id }
      end
    end

    describe "DELETE #destroy" do
      it_should_behave_like "has to be logged in" do
        before { delete :destroy, id: picture.to_param, gallery_id: picture.gallery_id }
      end
    end
  end

  context "when not authorized user is logged in" do
    let(:picture) { create :picture }
    before(:each) { login_user }

    describe "GET #index" do
      it_should_behave_like "has insufficient rights" do
        before { get :index, gallery_id: picture.gallery_id }
      end
    end

    describe "GET #new" do
      it_should_behave_like "has insufficient rights" do
        before { get :new, gallery_id: picture.gallery_id }
      end
    end

    describe "POST #create" do
      it_should_behave_like "has insufficient rights" do
        before { post :create, picture: attributes_for(:picture), gallery_id: picture.gallery_id }
      end
    end

    describe "GET #edit" do
      it_should_behave_like "has insufficient rights" do
        before { get :edit, id: picture.to_param, gallery_id: picture.gallery_id }
      end
    end

    describe "PUT #update" do
      it_should_behave_like "has insufficient rights" do
        before { put :update, id: picture.to_param, picture: attributes_for(:picture), gallery_id: picture.gallery_id }
      end
    end

    describe "DELETE #destroy" do
      it_should_behave_like "has insufficient rights" do
        before { delete :destroy, id: picture.to_param, gallery_id: picture.gallery_id }
      end
    end
  end
end
