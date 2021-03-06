require 'spec_helper'

describe ContactsController do
  describe 'GET #new' do
    before(:each) { get :new }
    it { should render_template(:new) }
  end

  describe 'POST #create' do
    context 'with invalid data' do
      before(:each) do
        Contact.any_instance.stub(:valid?).and_return(false)
        post :create, contact: attributes_for(:contact)
      end

      it { should render_template(:new) }
    end

    context 'with valid data' do
      before(:each) { post :create, contact: attributes_for(:contact) }

      it { flash[:notice].should_not be_nil }
      it { response.should redirect_to :contact }
      it { ActionMailer::Base.deliveries.last.subject.should eq 'Spec Test Subject' }
    end
  end
end
