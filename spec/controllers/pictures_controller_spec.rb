require 'spec_helper'

describe PicturesController do
  # after { Gallery.destroy_all }
  # after { Picture.destroy_all }

  let!(:gallery) { create :gallery_with_pictures }

  context 'when user is logged in' do
    before { login_user }

    describe 'GET #show' do
      before { get :show, gallery_id: gallery.to_param, id: gallery.pictures.first.to_param }

      it { response.status.should eq 200 }
      it { assigns(:picture).should eq gallery.pictures.first }
      it 'sends file' do
        controller.stub(:render)
        controller.should_receive(:send_file)

        get :show, gallery_id: gallery.to_param, id: gallery.public_pictures.first.to_param
      end
    end
  end

  context 'when user is not logged in' do
    describe 'GET #show for public picture' do
      before { get :show, gallery_id: gallery.to_param, id: gallery.public_pictures.first.to_param }

      it { response.status.should eq 200 }
      it { assigns(:picture).should eq gallery.public_pictures.first }
      it 'sends file' do
        controller.stub(:render)
        controller.should_receive(:send_file)

        get :show, gallery_id: gallery.to_param, id: gallery.public_pictures.first.to_param
      end
    end
    describe 'GET #show for internal picture' do
      before { get :show, gallery_id: gallery.to_param, id: gallery.internal_pictures.first.to_param }

      it { response.status.should eq 401 }
      it 'sends file' do
        controller.stub(:render)
        controller.should_not_receive(:send_file)

        get :show, gallery_id: gallery.to_param, id: gallery.public_pictures.first.to_param
      end
    end
  end
end
