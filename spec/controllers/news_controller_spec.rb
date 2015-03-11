require 'cancan/matchers'
require 'spec_helper'

shared_examples_for 'an accessible news' do
  it 'should have successful response' do
    get :show, id: news.to_param
    response.should be_success
  end

  it 'should be able to read news' do
    get :show, id: news.to_param
    should be_able_to(:read, assigns(:news))
  end
end

shared_examples_for 'an inaccessible news' do
  it 'should not find record' do
    get :show, id: news.to_param
    response.status.should eq(401)
  end

  it 'should not be able to access news' do
    get :show, id: news.to_param
    should_not be_able_to(:read, assigns(:news))
  end
end

describe NewsController do
  let!(:category) { create(:category) }
  let!(:regular_news) { create(:news) }
  let!(:private_news) { create(:news, :members_only) }
  let!(:unpublished_news) { create(:news, :unpublished) }
  let!(:upcoming_news) { create(:news, :upcoming) }
  let!(:categorized_news) { create(:news, category: category) }
  let!(:private_categorized_news) { create(:news, :members_only, category: category) }

  describe 'GET #index' do
    context 'when user is logged in' do
      context 'and no category is filtered' do
        before(:each) { login_user }
        before(:each) { get :index }
        subject { assigns(:news) }

        it { response.should be_success }
        it { should include(regular_news) }
        it { should include(private_news) }
        it { should include(categorized_news) }
        it { should include(private_categorized_news) }
        it { should_not include(unpublished_news) }
        it { should_not include(upcoming_news) }
      end

      context 'and category is filtered' do
        before(:each) { login_user }
        before(:each) { get :index, category: categorized_news.category.to_param }
        subject { assigns(:news) }

        it { response.should be_success }
        it { should include(categorized_news) }
        it { should include(private_categorized_news) }
        it { should_not include(regular_news) }
        it { should_not include(private_news) }
        it { should_not include(unpublished_news) }
        it { should_not include(upcoming_news) }
      end
    end

    context 'when user is not logged in' do
      context 'and no category is filtered' do
        before(:each) { get :index }
        subject { assigns(:news) }

        it { response.should be_success }
        it { should include(regular_news) }
        it { should include(categorized_news) }
        it { should_not include(private_news) }
        it { should_not include(unpublished_news) }
        it { should_not include(upcoming_news) }
        it { should_not include(private_categorized_news) }
      end

      context 'and category is filtered' do
        before(:each) { get :index, category: categorized_news.category.to_param }
        subject { assigns(:news) }

        it { response.should be_success }
        it { should include(categorized_news) }
        it { should_not include(regular_news) }
        it { should_not include(private_news) }
        it { should_not include(unpublished_news) }
        it { should_not include(upcoming_news) }
        it { should_not include(private_categorized_news) }
      end
    end
  end

  describe 'GET #show' do
    context 'when user is logged in' do
      before(:each) { login_user }

      context 'when news is published' do
        it_should_behave_like 'an accessible news' do
          let(:news) { create(:news) }
        end
      end

      context 'when news it published and for members only' do
        it_should_behave_like 'an accessible news' do
          let(:news) { create(:news, :members_only) }
        end
      end

      context 'when news it unpublished' do
        it_should_behave_like 'an inaccessible news' do
          let(:news) { create(:news, :unpublished) }
        end

        it_should_behave_like 'an inaccessible news' do
          let(:news) { create(:news, :upcoming) }
        end
      end
    end

    context 'when user is not logged in' do
      context 'when news is published' do
        it_should_behave_like 'an accessible news' do
          let(:news) { create(:news) }
        end
      end

      context 'when news it published and for members only' do
        it_should_behave_like 'an inaccessible news' do
          let(:news) { create(:news, :members_only) }
        end
      end

      context 'when news it unpublished' do
        it_should_behave_like 'an inaccessible news' do
          let(:news) { create(:news, :unpublished) }
        end

        it_should_behave_like 'an inaccessible news' do
          let(:news) { create(:news, :upcoming) }
        end
      end
    end
  end
end
