require 'spec_helper'

describe Admin::NewsController do
  let!(:category) { create(:category) }
  let!(:regular_news) { create(:news) }
  let!(:private_news) { create(:news, :members_only) }
  let!(:unpublished_news) { create(:news, :unpublished) }
  let!(:upcoming_news) { create(:news, :upcoming) }
  let!(:categorized_news) { create(:news, category: category) }

  context 'when user not logged in' do
    describe 'GET #index' do
      it_should_behave_like 'has to be logged in' do
        before { get :index }
      end
    end

    describe 'GET #new' do
      it_should_behave_like 'has to be logged in' do
        before { get :new }
      end
    end

    describe 'POST #create' do
      it_should_behave_like 'has to be logged in' do
        before { post :create, news: attributes_for(:news) }
      end
    end

    describe 'GET #edit' do
      it_should_behave_like 'has to be logged in' do
        before { get :edit, id: regular_news.id }
      end
    end

    describe 'PUT #update' do
      it_should_behave_like 'has to be logged in' do
        before { put :update, id: regular_news.id, news: regular_news }
      end
    end

    describe 'DELETE #destroy' do
      it_should_behave_like 'has to be logged in' do
        before { delete :destroy, id: regular_news.id }
      end
    end

    describe 'GET #publish' do
      it_should_behave_like 'has to be logged in' do
        before { put :update, id: regular_news.id, news: regular_news }
      end
    end

    describe 'GET #unpublish' do
      it_should_behave_like 'has to be logged in' do
        before { put :update, id: regular_news.id, news: regular_news }
      end
    end
  end

  context 'when not authorized user is logged in' do
    before(:each) { login_user }

    describe 'GET #index' do
      it_should_behave_like 'has insufficient rights' do
        before { get :index }
      end
    end

    describe 'GET #new' do
      it_should_behave_like 'has insufficient rights' do
        before { get :new }
      end
    end

    describe 'POST #create' do
      it_should_behave_like 'has insufficient rights' do
        before { post :create, news: attributes_for(:news) }
      end
    end

    describe 'GET #edit' do
      it_should_behave_like 'has insufficient rights' do
        before { get :edit, id: regular_news.id }
      end
    end

    describe 'PUT #update' do
      it_should_behave_like 'has insufficient rights' do
        before { put :update, id: regular_news.id, news: regular_news }
      end
    end

    describe 'DELETE #destroy' do
      it_should_behave_like 'has insufficient rights' do
        before { delete :destroy, id: regular_news.id }
      end
    end

    describe 'GET #publish' do
      it_should_behave_like 'has insufficient rights' do
        before { put :update, id: regular_news.id, news: regular_news }
      end
    end

    describe 'GET #unpublish' do
      it_should_behave_like 'has insufficient rights' do
        before { put :update, id: regular_news.id, news: regular_news }
      end
    end
  end

  context 'when authorized user is logged in' do
    before(:each) { login_manager }

    describe 'GET #index without Category' do
      before(:each) { get :index }
      subject { assigns(:news) }

      it { response.status.should eq(200) }
      it { should include(regular_news) }
      it { should include(private_news) }
      it { should include(unpublished_news) }
      it { should include(upcoming_news) }
      it { should include(categorized_news) }
    end

    describe 'GET #index with Category' do
      before(:each) { get(:index, category: categorized_news.category.id) }
      subject { assigns(:news) }

      it { response.status.should eq(200) }
      it { should include(categorized_news) }

      it { should_not include(regular_news) }
      it { should_not include(private_news) }
      it { should_not include(unpublished_news) }
      it { should_not include(upcoming_news) }
    end

    describe 'GET #new' do
      before(:each) { get :new }

      it { response.status.should eq(200) }
      it { assigns(:news).should be_a_new(News) }
    end

    describe 'POST #create' do
      describe 'with valid params' do
        it 'creates a new News' do
          expect {
            post :create, news: attributes_for(:news)
          }.to change(News, :count).by(1)
        end

        it 'assigns a newly created news as @news' do
          post :create, news: attributes_for(:news)
          assigns(:news).should be_a(News)
          assigns(:news).should be_persisted
        end

        it 'redirects to the index' do
          post :create, news: attributes_for(:news)
          response.should redirect_to(:admin_news_index)
        end
      end

      describe 'with invalid params' do
        it 'assigns a newly created but unsaved news as @news' do
          # Trigger the behavior that occurs when invalid params are submitted
          News.any_instance.stub(:save).and_return(false)
          post :create, news: attributes_for(:news)
          assigns(:news).should be_a_new(News)
        end

        it 're-renders the \'new\' template' do
          # Trigger the behavior that occurs when invalid params are submitted
          News.any_instance.stub(:save).and_return(false)
          post :create, news: attributes_for(:news)
          response.should render_template('new')
        end
      end
    end

    describe 'GET edit' do
      before(:each) { get :edit, id: regular_news.id }

      it { response.status.should eq(200) }
      it { assigns(:news).should eq(regular_news) }
    end

    describe 'PUT #update' do
      describe 'with valid params' do
        before(:each) do
          put :update, id: regular_news.id, news: { title: 'Neue Nachricht', body: 'Test1234' }
        end

        it { expect(assigns(:news).title).to eq 'Neue Nachricht' }
        it { expect(assigns(:news).body).to eq 'Test1234' }
        it { expect(response.should).to redirect_to(:admin_news_index) }
      end

      describe 'with invalid params' do
        # Trigger the behavior that occurs when invalid params are submitted
        before(:each) { News.any_instance.stub(:update).and_return(false) }

        it 'assigns the news as @news' do
          put :update, id: regular_news.id, news: attributes_for(:news, :upcoming)
          assigns(:news).should eq(regular_news)
        end

        it 're-renders the \'edit\' template' do
          put :update, id: regular_news.id, news: attributes_for(:news, :upcoming)
          response.should render_template(:edit)
        end
      end
    end

    describe 'DELETE destroy' do
      it 'destroys the requested news' do
        expect {
          delete :destroy, id: regular_news.id
        }.to change(News, :count).by(-1)
      end

      it 'redirects to the news list' do
        delete :destroy, id: regular_news.id
        response.should redirect_to(:admin_news_index)
      end
    end

    describe 'PUT #publish' do
      it 'sets published_at' do
        News.stub(:find).and_return(unpublished_news)
        unpublished_news.should_receive(:update).and_call_original
        put :publish, id: unpublished_news.id

        regular_news.published_at.should_not be_nil

        # compare integers due to timezone changes
        regular_news.published_at.to_i.should be <= DateTime.now.to_i
      end

      it 'redirects to the news list' do
        put :publish, id: unpublished_news.id
        response.should redirect_to(:admin_news_index)
      end
    end

    describe 'PUT #unpublish' do
      it 'unsets published_at' do
        News.stub(:find).and_return(regular_news)
        regular_news.should_receive(:update).with(published_at: nil).and_call_original
        put :unpublish, id: regular_news.id

        regular_news.published_at.should be_nil
      end

      it 'redirects to the news list' do
        put :unpublish, id: regular_news.id
        response.should redirect_to(:admin_news_index)
      end
    end
  end
end
