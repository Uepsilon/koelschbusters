# == Schema Information
#
# Table name: news
#
#  id           :integer          not null, primary key
#  title        :string(255)
#  body         :text
#  teaser       :text
#  user_id      :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  published_at :datetime
#  internal     :boolean          default(FALSE)
#  category_id  :integer
#  notified_at  :time
#

require 'spec_helper'

describe News do
  let!(:news)              { create(:news) }
  let!(:unpublished_news)  { create(:news, :unpublished) }
  let!(:upcoming_news)     { create(:news, :upcoming) }
  let!(:private_news)      { create(:news, :members_only) }

  describe 'Validation' do
    it 'has a valid factory' do
      news.should be_valid
    end

    it { news.should validate_presence_of(:title) }
    it { news.should validate_presence_of(:body) }
    it { news.should validate_presence_of(:user_id) }
  end

  describe '#to_param' do
    it 'returns a slug' do
      news.to_param.should start_with("#{news.id}-random-news-title")
    end
  end

  describe '#published?' do
    it { news.published?.should be_true }
    it { unpublished_news.published?.should be_false }
    it { upcoming_news.published?.should be_false }
  end

  describe 'scopes' do
    context 'when internal-flag is used' do
      subject { News.ffa.all }

      it { should include(news) }
      it { should_not include(private_news) }
    end

    context 'when published_at is used' do
      subject { News.published.all }

      it { should include(news) }
      it { should_not include(unpublished_news) }
      it { should_not include(upcoming_news) }
    end
  end
end
