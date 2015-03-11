require 'spec_helper'

describe UsersController do
  context 'when user is not logged in' do
    describe 'GET #show' do
      it_should_behave_like 'has to be logged in' do
        before(:each) { get :show }
      end
    end

    describe 'GET #edit' do
      it_should_behave_like 'has to be logged in' do
        before(:each) { get :edit }
      end
    end

    describe 'PUT #update' do
      let(:user) { create(:user) }
      it_should_behave_like 'has to be logged in' do
        before(:each) { put :update, user: user.attributes }
      end
    end

    describe 'GET #edit_login' do
      it_should_behave_like 'has to be logged in' do
        before(:each) { get :edit_login }
      end
    end

    describe 'PUT #update_login' do
      let(:user) { create(:user) }
      it_should_behave_like 'has to be logged in' do
        before(:each) { put :update_login, id: user.id, user: user.attributes }
      end
    end
  end

  context 'when user is logged in ' do
    let(:user) { create(:user) }
    before(:each) { login_user(user) }

    describe 'GET #show' do
      before(:each) { get :show }

      it { response.status.should eq(200) }
      it { assigns(:user).should eq(user) }
    end

    describe 'GET #edit' do
      before(:each) { get :edit }

      it { response.status.should eq(200) }
      it { assigns(:user).should eq(user) }
    end

    describe 'PUT #update' do
      context 'with valid params' do
        before(:each) { put :update, user: { first_name: 'Donald', last_name: 'Duck' } }

        it { should redirect_to(:user) }
        it { assigns(:user).should eq(user) }
        it { assigns(:user).first_name.should eq('Donald') }
        it { assigns(:user).last_name.should eq('Duck') }
      end

      context 'with invalid params' do
        before(:each) do
          User.any_instance.stub(:update).and_return(false)
          put :update, user: attributes_for(:user)
        end

        it { response.status.should eq(200) }
        it { should render_template(:edit) }
        it { assigns(:user).should eq(user) }
        it { assigns(:user).first_name.should eq(user.first_name) }
        it { assigns(:user).last_name.should eq(user.last_name) }
      end
    end

    describe 'GET #edit_login' do
      before(:each) { get :edit_login }

      it { response.status.should eq(200) }
      it { assigns(:user).should eq(user) }
    end

    describe 'PUT #update_login' do
      context 'with valid params' do
        before(:each) { put :update_login, user: { current_password: 'Test12345', email: 'test@example.com', email_confirmation: 'test@example.com' } }

        it { should redirect_to(:user) }
        it { assigns(:user).should eq(user) }
        it { assigns(:user).unconfirmed_email.should eq('test@example.com') }
        it { assigns(:user).confirmation_token.should_not be_nil }
        it { assigns(:user).confirmation_sent_at.should_not be_nil }
      end

      context 'with invalid params' do
        before(:each) do
          User.any_instance.stub(:update_with_password).and_return(false)
          put :update_login, user: attributes_for(:user)
        end

        it { response.status.should eq(200) }
        it { should render_template(:edit_login) }
        it { assigns(:user).should eq(user) }
        it { assigns(:user).email.should eq(user.email) }
      end
    end
  end
end
