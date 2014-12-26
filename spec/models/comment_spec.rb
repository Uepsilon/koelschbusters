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
    pending "add some examples to (or delete) #{__FILE__}"
end
