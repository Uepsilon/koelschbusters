require 'spec_helper'

describe Admin::UsersController do
  context "when user is not logged in" do
    describe "GET #index" do
      it_should_behave_like "has to be logged in" do
        before(:each) { get :index }
      end
    end

    describe "GET #new" do
      it_should_behave_like "has to be logged in" do
        before(:each) { get :new }
      end
    end

    describe "POST #create" do
      it_should_behave_like "has to be logged in" do
        before(:each) { post :create, user: attributes_for(:user) }
      end
    end

    describe "GET #edit" do
      let(:user) { create(:user) }
      it_should_behave_like "has to be logged in" do
        before(:each) { get :edit, id: user.to_param }
      end
    end

    describe "PUT #update" do
      let(:user) { create(:user) }
      it_should_behave_like "has to be logged in" do
        before(:each) { put :update, id: user.to_param, user: attributes_for(:user) }
      end
    end

    describe "DELETE #destroy" do
      let(:user) { create(:user) }
      it_should_behave_like "has to be logged in" do
        before(:each) { delete :destroy, id: user.to_param }
      end
    end
  end

  context "when not authorized user is logged in" do
    let!(:user) { create(:user) }
    before(:each) { login_user(user) }

    describe "GET #index" do
      it_should_behave_like "has insufficient rights" do
        before(:each) { get :index }
      end
    end

    describe "GET #new" do
      it_should_behave_like "has insufficient rights" do
        before(:each) { get :new }
      end
    end

    describe "POST #create" do
      it_should_behave_like "has insufficient rights" do
        before(:each) { post :create, user: attributes_for(:user) }
      end
    end

    describe "GET #edit" do
      it_should_behave_like "has insufficient rights" do
        before(:each) { get :edit, id: user.to_param }
      end
    end

    describe "PUT #update" do
      it_should_behave_like "has insufficient rights" do
        before(:each) { put :update, id: user.to_param, user: attributes_for(:user) }
      end
    end

    describe "DELETE #destroy" do
      it_should_behave_like "has insufficient rights" do
        before(:each) { delete :destroy, id: user.to_param }
      end
    end
  end

  context "when authorized user is logged in" do
    let!(:admin) { create(:user, :admin) }
    let!(:user1) { create(:user) }
    let!(:user2) { create(:user) }
    before(:each) { login_admin(admin) }

    describe "GET #index" do
      before(:each) { get :index }

      it { response.status.should be(200) }
      it { assigns(:users).should include(user1) }
      it { assigns(:users).should include(user2) }
    end

    describe "GET #new" do
      before(:each) { get :new }

      it { response.status.should be(200) }
      it { assigns(:user).should be_a_new(User) }
    end

    describe "POST #create" do
      context "with valid params" do

        it "should increase Usercount by One" do
          expect {
            post :create, user: attributes_for(:user)
          }.to change(User, :count).by(1)
        end

        context "with request in before block" do
          before(:each) { post :create, user: attributes_for(:user) }
          it { should redirect_to(:admin_users) }
          it { assigns(:user).should be_a(User) }
          it { assigns(:user).should be_persisted }
        end
      end

      context "with invalid params" do
        before(:each) { User.any_instance.stub(:save).and_return(false) }
        before(:each) { post :create, user: attributes_for(:user) }

        it { response.status.should be(200) }
        it { assigns(:user).should be_a_new(User) }
        it { should render_template(:new) }
      end
    end

    describe "GET #edit" do
      context "with different user" do
        let(:user) { create(:user) }

        before(:each) { get :edit, id: user.to_param }

        it { response.status.should eq(200) }
        it { assigns(:user).should eq(user) }
      end

      context "with current_user" do
        before(:each) { get :edit, id: admin.to_param }
        it { should redirect_to(:admin_users) }
      end
    end

    describe "PUT #update" do
      context "with different user" do
        let(:user) { create(:user) }
        context "with valid params" do
          before(:each) { put :update, id: user.to_param, user: { first_name: "Donald", last_name: "Duck" }}

          it { should redirect_to(:admin_users) }
          it { assigns(:user).first_name.should eq("Donald") }
          it { assigns(:user).last_name.should eq("Duck") }
        end

        context "with invalid params" do
          before(:each) { User.any_instance.stub(:update_attributes).and_return(false) }
          before(:each) { put :update, id: user.to_param, user: { first_name: "Donald", last_name: "Duck" }}

          it { response.status.should eq(200) }
          it { assigns(:user).should eq(user) }
          it { should render_template(:edit) }
        end
      end

      context "with current_user" do
        before(:each) { put :update, id: admin.to_param }
        it { should redirect_to(:admin_users) }
      end
    end

    describe "DELETE #destroy" do
      it "removes user" do
        expect {
          delete :destroy, id: user1.to_param
        }.to change(User, :count).by(-1)
      end

      it "redirect to admin/users" do
        delete :destroy, id: user1.to_param
        subject.should redirect_to(:admin_users)
      end
    end
  end
end
