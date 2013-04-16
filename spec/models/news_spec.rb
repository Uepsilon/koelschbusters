require 'spec_helper'

describe News do
  before(:each) {News.destroy_all}

  describe "#to_param" do
    subject {create(:news)}

    it 'returns a slug' do
      subject.to_param.should eq("#{subject.id}-random-news-title-1")
    end
  end

  describe 'scopes' do
    let(:news)              {create(:news)}
    let(:private_news)      {create(:news, :members_only)}
    let(:unpublished_news)  {create(:news, :unpublished)}
    let(:future_news)       {create(:news, :published_in_future)}

    context "when internal-flag is used" do
      subject {News.ffa.all}

      it {should include(news)}
      it {should_not include(private_news)}
    end

    context "when published_at is used" do
      subject {News.published.all}

      it {should include(news)}
      it {should_not include(unpublished_news)}
      it {should_not include(future_news)}
    end
  end
end
