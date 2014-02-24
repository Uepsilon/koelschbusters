require 'spec_helper'

describe ContactsController do
  describe "GET #new" do
    before(:each) { get :new }
    it { should render_template(:new) }
  end

  describe "POST #create" do
    context "with invalid data" do
      before(:each) { post :create, contact: {} }
      it { should render_template(:new) }
    end

    context "with valid data" do
      before(:each) { post :create, contact: {name: "Max Mustermann", text: "Lorem Ipsum", email: "max@mustermann.de", subject: "Mustermail"}}

      it { flash[:notice].should_not be_nil }
      it { response.should redirect_to :contact }
      it { ActionMailer::Base.deliveries.last.subject.should eq "Mustermail" }
    end
  end
end
