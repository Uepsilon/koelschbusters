# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  username         :string(255)
#  body             :text
#  user_id          :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  activated_at     :datetime
#  commentable_id   :integer
#  commentable_type :string(255)
#

require 'spec_helper'

describe Comment do
  let!(:user) { create :user }

  let!(:anonymous_news_comment) { create :news_comment, :anonymous }
  let!(:user_news_comment) { create :news_comment, user: user }

  describe 'Validation' do
    it { anonymous_news_comment.should be_valid }
    it { user_news_comment.should be_valid }
    it { should validate_presence_of(:body) }
  end

  describe 'Methods' do
    it { anonymous_news_comment.guest_comment.should be_true }
    it { user_news_comment.guest_comment.should be_false }

    it 'active anonymous news comment' do
      anonymous_news_comment.active?.should be_false
      anonymous_news_comment.activate!
      anonymous_news_comment.active?.should be_true
    end

    it 'deactive user news comment' do
      user_news_comment.active?.should be_true
      user_news_comment.deactivate!
      user_news_comment.active?.should be_false
    end
  end
end
