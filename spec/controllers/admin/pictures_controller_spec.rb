require 'spec_helper'

describe Admin::PicturesController do
  # Cleanup mess after test
  after(:each) {
    Gallery.destroy_all
    Picture.destroy_all
  }
  # context "when user not logged in" do
  #   let(:picture) { create :picture }

  #   describe "GET #index" do
  #     it_should_behave_like "has to be logged in" do
  #       before { get :index, gallery_id: picture.gallery_id }
  #     end
  #   end

  #   describe "GET #new" do
  #     it_should_behave_like "has to be logged in" do
  #       before { get :new, gallery_id: picture.gallery_id }
  #     end
  #   end

  #   describe "POST #create" do
  #     it_should_behave_like "has to be logged in" do
  #       before { post :create, picture: attributes_for(:picture), gallery_id: picture.gallery_id }
  #     end
  #   end

  #   describe "GET #edit" do
  #     it_should_behave_like "has to be logged in" do
  #       before { get :edit, id: picture.to_param, gallery_id: picture.gallery_id }
  #     end
  #   end

  #   describe "PUT #update" do
  #     it_should_behave_like "has to be logged in" do
  #       before { put :update, id: picture.to_param, picture: attributes_for(:picture), gallery_id: picture.gallery_id }
  #     end
  #   end

  #   describe "DELETE #destroy" do
  #     it_should_behave_like "has to be logged in" do
  #       before { delete :destroy, id: picture.to_param, gallery_id: picture.gallery_id }
  #     end
  #   end
  # end

  # context "when not authorized user is logged in" do
  #   let(:picture) { create :picture }
  #   before(:each) { login_user }

  #   describe "GET #index" do
  #     it_should_behave_like "has insufficient rights" do
  #       before { get :index, gallery_id: picture.gallery_id }
  #     end
  #   end

  #   describe "GET #new" do
  #     it_should_behave_like "has insufficient rights" do
  #       before { get :new, gallery_id: picture.gallery_id }
  #     end
  #   end

  #   describe "POST #create" do
  #     it_should_behave_like "has insufficient rights" do
  #       before { post :create, picture: attributes_for(:picture), gallery_id: picture.gallery_id }
  #     end
  #   end

  #   describe "GET #edit" do
  #     it_should_behave_like "has insufficient rights" do
  #       before { get :edit, id: picture.to_param, gallery_id: picture.gallery_id }
  #     end
  #   end

  #   describe "PUT #update" do
  #     it_should_behave_like "has insufficient rights" do
  #       before { put :update, id: picture.to_param, picture: attributes_for(:picture), gallery_id: picture.gallery_id }
  #     end
  #   end

  #   describe "DELETE #destroy" do
  #     it_should_behave_like "has insufficient rights" do
  #       before { delete :destroy, id: picture.to_param, gallery_id: picture.gallery_id }
  #     end
  #   end
  # end

  context "when authorized user is logged in" do
    before(:each) { login_manager }

    let!(:gallery) { create :gallery_with_pictures }

    describe "GET #index" do
      before(:each) { get :index, gallery_id: gallery.to_param }
      subject { assigns :pictures }

      it { response.status.should eq 200 }
      it { assigns(:gallery).should eq gallery }
      it "loads pictures from gallery" do
        gallery.pictures.each do |picture|
          subject.should include picture
        end
      end
    end

    describe "GET #new" do
      before(:each) { get :new, gallery_id: gallery.to_param }
      subject { assigns :picture }

      it { response.status.should eq 200 }
      it { subject.should be_a_new Picture }
      it { assigns(:gallery).should eq gallery }
    end

    describe "POST #create" do
      context "with valid params" do

        it "creates a Picture" do
          expect {
            post :create, picture: attributes_for(:picture), gallery_id: gallery.to_param
          }.to change(Picture, :count).by(1)
        end

        context "" do
          before(:each) { post :create, picture: attributes_for(:picture), gallery_id: gallery.to_param }

          it { response.should redirect_to([:admin, gallery, :pictures]) }
          it { assigns(:picture).should be_a Picture }
          it { assigns(:picture).should be_persisted }
          it { assigns(:gallery).should eq gallery }
        end
      end

      context "with invalid params" do
      before(:each) { Picture.any_instance.stub(:save).and_return(false) }
      before(:each) { post :create, picture: attributes_for(:picture), gallery_id: gallery.to_param }

      it { response.status.should eq 200 }
      it { response.should render_template :new }
      it { assigns(:picture).should be_a_new Picture }
      it { assigns(:gallery).should eq gallery }
      end
    end

    describe "GET #edit" do
      before(:each) { get :edit, gallery_id: gallery.to_param, id: gallery.pictures.first.to_param }

      it { response.status.should eq 200 }
      it { assigns(:picture).should eq gallery.pictures.first }
      it { assigns(:gallery).should eq gallery }

    end

    describe "PUT #update" do
      context "with valid params" do
        it "updates picture" do
          Picture.any_instance.should_receive(:update_attributes).with({internal: true}.stringify_keys )
          put :update, gallery_id: gallery.to_param, id: gallery.public_pictures.first.to_param, picture: { internal: true }
        end
        context "" do
          before(:each) { put :update, gallery_id: gallery.to_param, id: gallery.public_pictures.first.to_param, picture: { internal: true }}
          it { response.should redirect_to [:admin, gallery, :pictures] }
          it { assigns(:picture).internal.should be_true }
          it { assigns(:gallery).should eq gallery }
        end
      end

      context "with invalid params" do
        before(:each) { Picture.any_instance.stub(:update_attributes).and_return(false) }
        before(:each) { put :update, gallery_id: gallery.to_param, id: gallery.public_pictures.first.to_param, picture: { internal: true }}

        it { response.status.should eq 200 }
        it { response.should render_template :edit }
        it { assigns(:gallery).should eq gallery }
        it { assigns(:picture).should eq gallery.public_pictures.first }
      end
    end

    describe "DELETE #destroy" do
      it "deletes picture" do
        expect {
          delete :destroy, gallery_id: gallery.to_param, id: gallery.pictures.first.to_param
        }.to change(Picture, :count).by(-1)
      end

      it "redirects to pictures" do
        delete :destroy, gallery_id: gallery.to_param, id: gallery.pictures.first.to_param
        response.should redirect_to [:admin, gallery, :pictures]
      end
    end
  end
end
