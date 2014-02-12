require 'spec_helper'

describe Admin::CategoriesController do
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
        before(:each) { post :create, category: attributes_for(:category) }
      end
    end

    describe "GET #edit" do
      let(:category) { create(:category) }
      it_should_behave_like "has to be logged in" do
        before(:each) { get :edit, id: category.to_param }
      end
    end

    describe "PUT #update" do
      let(:category) { create(:category) }
      it_should_behave_like "has to be logged in" do
        before(:each) { put :update, id: category.to_param, category: attributes_for(:category) }
      end
    end

    describe "DELETE #destroy" do
      let(:category) { create(:category) }
      it_should_behave_like "has to be logged in" do
        before(:each) { delete :destroy, id: category.to_param }
      end
    end
  end

  context "when not authorized user is logged in" do
    let!(:user) { create(:user) }
    let!(:category) { create(:category) }
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
        before(:each) { post :create, category: attributes_for(:category) }
      end
    end

    describe "GET #edit" do
      it_should_behave_like "has insufficient rights" do
        before(:each) { get :edit, id: category.to_param }
      end
    end

    describe "PUT #update" do
      it_should_behave_like "has insufficient rights" do
        before(:each) { put :update, id: category.to_param, category: attributes_for(:category) }
      end
    end

    describe "DELETE #destroy" do
      it_should_behave_like "has insufficient rights" do
        before(:each) { delete :destroy, id: category.to_param }
      end
    end
  end

  context "when authorized user is logged in" do
    let!(:admin) { create(:user, :admin) }
    let!(:c1) { create(:category) }
    let!(:c2) { create(:category) }
    before(:each) { login_admin(admin) }

    describe "GET #index" do
      before(:each) { get :index }

      it { response.status.should be(200) }
      it { assigns(:categories).should include(c1) }
      it { assigns(:categories).should include(c2) }
    end

    describe "GET #new" do
      before(:each) { get :new }

      it { response.status.should be(200) }
      it { assigns(:category).should be_a_new(Category) }
    end

    describe "POST #create" do
      context "with valid params" do

        it "should increase Count by one" do
          expect {
            post :create, category: attributes_for(:category)
          }.to change(Category, :count).by(1)
        end

        context "with request in before block" do
          before(:each) { post :create, category: attributes_for(:category) }
          it { should redirect_to(:admin_categories) }
          it { assigns(:category).should be_a(Category) }
          it { assigns(:category).should be_persisted }
        end
      end

      context "with invalid params" do
        before(:each) { Category.any_instance.stub(:save).and_return(false) }
        before(:each) { post :create, category: attributes_for(:category) }

        it { response.status.should be(200) }
        it { assigns(:category).should be_a_new(Category) }
        it { should render_template(:new) }
      end
    end

    describe "GET #edit" do
      let(:category) { create(:category) }

      before(:each) { get :edit, id: category.to_param }

      it { response.status.should eq(200) }
      it { assigns(:category).should eq(category) }
    end

    describe "PUT #update" do
      let(:category) { create(:category) }
      context "with valid params" do
        before(:each) { put :update, id: category.to_param, category: { title: "Lorem Ipsum", slug: "lorem-ipsum" }}

        it { should redirect_to(:admin_categories) }
        it { assigns(:category).title.should eq("Lorem Ipsum") }
        it { assigns(:category).slug.should eq("lorem-ipsum") }
      end

      context "with invalid params" do
        before(:each) { Category.any_instance.stub(:update_attributes).and_return(false) }
        before(:each) { put :update, id: category.to_param, category: { title: "Lorem Ipsum", slug: "lorem-ipsum" }}

        it { response.status.should eq(200) }
        it { assigns(:category).should eq(category) }
        it { should render_template(:edit) }
      end
    end

    describe "DELETE #destroy" do
      it "removes category" do
        expect {
          delete :destroy, id: c1.to_param
        }.to change(Category, :count).by(-1)
      end

      it "redirect to admin/categories" do
        delete :destroy, id: c1.to_param
        subject.should redirect_to(:admin_categories)
      end
    end
  end
end
