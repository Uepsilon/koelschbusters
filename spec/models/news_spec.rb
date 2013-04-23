require 'spec_helper'

describe News do
  before(:each) { News.destroy_all }

  describe "Validation" do

    it "should be invalid without a title" do
      subject.should be_invalid
      subject.errors.should include(:title)
    end

    it "should be invalid without a teaser" do
      subject.should be_invalid
      subject.errors.should include(:teaser)
    end

    it "should be invalid without a body" do
      subject.should be_invalid
      subject.errors.should include(:body)
    end
  end

  describe "#to_param" do
    # reload to reset sequence => make sure title-1 matches
    # (otherwise depends on order of tests)
    before { FactoryGirl.reload }

    subject { create(:news) }

    it 'returns a slug' do
      subject.to_param.should eq("#{subject.id}-random-news-title-1")
    end
  end

  describe "#published?" do
    let(:news)              { create(:news) }
    let(:unpublished_news)  { create(:news, :unpublished) }
    let(:upcoming_news)     { create(:news, :upcoming) }

    it { news.published?.should be_true }
    it { unpublished_news.published?.should be_false }
    it { upcoming_news.published?.should be_false }
  end

  describe 'scopes' do
    let(:news)              { create(:news) }
    let(:private_news)      { create(:news, :members_only) }
    let(:unpublished_news)  { create(:news, :unpublished) }
    let(:upcoming_news)     { create(:news, :upcoming) }

    context "when internal-flag is used" do
      subject {News.ffa.all}

      it {should include(news)}
      it {should_not include(private_news)}
    end

    context "when published_at is used" do
      subject {News.published.all}

      it {should include(news)}
      it {should_not include(unpublished_news)}
      it {should_not include(upcoming_news)}
    end
  end
end
