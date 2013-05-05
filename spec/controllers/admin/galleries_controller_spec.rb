require 'spec_helper'

describe Admin::GalleriesController do
  context "when authorized user is logged in" do
    before(:each) { login_manager }

    describe "GET #index" do
      let(:gallery)               { create(:gallery) }
      let(:gallery_with_pictures) { create(:gallery_with_pictures) }
      before(:each)               { get :index }

      subject { assigns(:galleries) }

      it { response.status.should eq(200) }
      it { subject.should include gallery }
      it { subject.should include gallery_with_pictures }
    end

    describe "GET #new" do
      before(:each) { get :new }
      subject { assigns(:gallery) }

      it { response.status.should eq 200 }
      it { subject.should be_a_new(Gallery)}
    end

    describe "POST #create" do
      context "with valid params" do
        it "creates a new gallery" do
          expect {
              post :create, gallery: attributes_for(:gallery)
            }.to change(Gallery, :count).by(1)
        end

        context "" do
          before(:each) { post :create, gallery: attributes_for(:gallery) }
          subject { assigns(:gallery) }

          it { subject.should be_a Gallery }
          it { subject.should be_persisted }
          it { response.should redirect_to :admin_galleries}
        end
      end

      context "with invalid params" do
        it "creates a new gallery" do
          expect {
              post :create, gallery: nil
            }.to change(Gallery, :count).by(0)
        end

        context "" do
          before(:each) { post :create, gallery: nil }
          subject { assigns(:gallery) }

          it { subject.should be_a_new Gallery }
          it { subject.should_not be_persisted }
          it { response.should render_template :new}
        end
      end
    end

    describe "GET #edit" do
      let(:gallery) { create :gallery }
      before(:each) { get :edit, :id => gallery.to_param }
      subject { assigns :gallery }

      it { response.status.should eq 200 }
      it { subject.should eq gallery}
    end

    describe "PUT #update" do
      let(:gallery) { create :gallery }

      it "updates the gallery" do
        new_attributes = { title: 'New Title' }.stringify_keys
        Gallery.any_instance.stub(:update_attributes).with(new_attributes)
        put :update, id: gallery.to_param, gallery: { title: 'New Title' }

      end

      context "with valid params" do
        context "" do
          before(:each) { put :update, id: gallery.to_param, gallery: { title: 'New Title' }}
          subject { assigns(:gallery) }

          it { subject.title.should eq 'New Title' }
          it { response.should redirect_to :admin_galleries }
        end
      end

      context "with invalid params" do
        before(:each) { put :update, id: gallery.to_param, gallery: { title: nil }}
        subject { assigns(:gallery) }

        it { response.should render_template :edit }
        it { subject.should eq gallery }
      end
    end

    describe "DELETE #destroy" do
      let! (:gallery) { create :gallery }

      it "deletes gallery" do
        expect {
          delete :destroy, id: gallery.to_param
        }.to change(Gallery, :count).by(-1)
      end

      it "redirects to galleries" do
        delete :destroy, id: gallery.to_param
        response.should redirect_to :admin_galleries
      end
    end
  end
end