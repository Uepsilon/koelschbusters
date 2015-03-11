# == Schema Information
#
# Table name: events
#
#  id          :integer          not null, primary key
#  internal    :boolean
#  title       :string(255)
#  description :text
#  starts_at   :datetime
#  ends_at     :datetime
#  location    :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'spec_helper'

describe Event do
  context 'validations' do
    # it { should validate_presence_of(:internal) }
    # it { should validate_presence_of(:title) }
    # it { should validate_presence_of(:description) }
    # it { should validate_presence_of(:starts_at) }
    # it { should validate_presence_of(:ends_at) }
    # it { should validate_presence_of(:location) }
  end
end
