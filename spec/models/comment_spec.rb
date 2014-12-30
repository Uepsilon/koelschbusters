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
  subject { create :news_comment, :anonymous }
  describe 'Validation' do
    it 'has a valid factory' do
      subject.should be_valid
    end

    it { should validate_presence_of(:body) }
  end
end
