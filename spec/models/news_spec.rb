require 'spec_helper'

describe News do
  before(:each) { News.destroy_all}

  describe "#to_param" do
    it 'returns a slug' do
      news = create(:news)

      news.to_param.should eq("#{news.id}-random-news-title-1")
    end
  end

  context "when internal-flag is used" do
    let(:public_news)   {create(:news)}
    let(:private_news)  {create(:news, :members_only)}
    subject { news = News.ffa.all }

    it {should include(public_news)}
    it {should_not include(private_news)}
  end

  context "when published_at is used" do
    let(:published_news)    {create(:news)}
    let(:unpublished_news)  {create(:news, :unpublished)}
    let(:future_news)       {create(:news, :published_in_future)}

    subject { news = News.published.all }

    it {should include(published_news)}
    it {should_not include(unpublished_news)}
    it {should_not include(future_news)}
  end
end
