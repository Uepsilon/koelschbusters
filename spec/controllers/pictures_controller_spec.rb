require 'spec_helper'

describe PicturesController do
  let!(:gallery) { create :gallery_with_pictures }
  context "when user is logged in" do
    describe "GET #show" do
      before(:each) { get :show, gallery_id: gallery.to_params, id: gallery_with_pictures.pictures.first.to_param }

      it { response.should eq 200 }
      it { assigns(:picture).should eq gallery_with_pictures.pictures.first }
      it "sends file" do
        controller.stub(:render)
        controller.should_receive(:send_file)
      end
    end
  end

  context "when user is not logged in" do
    describe "GET #show for public picture" do
      before(:each) { get :show, gallery_id: gallery.to_params, id: gallery_with_pictures.public_pictures.first.to_param }

      it { response.should eq 200 }
      it { assigns(:picture).should }
      it "sends file" do
        controller.stub(:render)
        controller.should_receive(:send_file)
      end
    end
    describe "GET #show for internal picture" do
      before(:each) { get :show, gallery_id: gallery.to_params, id: gallery_with_pictures.internal_pictures.first.to_param }

      it { response.should eq 401 }
      it "sends file" do
        controller.stub(:render)
        controller.should_not_receive(:send_file)
      end
    end
  end
end
