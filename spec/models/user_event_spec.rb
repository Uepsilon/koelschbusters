# == Schema Information
#
# Table name: user_events
#
#  id            :integer          not null, primary key
#  event_id      :integer          not null
#  user_id       :integer          not null
#  participation :boolean          default(FALSE), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'spec_helper'

RSpec.describe UserEvent, type: :model do
  context 'validations' do
    it { should validate_presence_of(:event) }
    it { should validate_presence_of(:user) }

    it { should belong_to(:event) }
    it { should belong_to(:user) }
  end
end
