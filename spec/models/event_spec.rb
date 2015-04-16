# == Schema Information
#
# Table name: events
#
#  id          :integer          not null, primary key
#  internal    :boolean          default(TRUE)
#  title       :string           not null
#  description :text             not null
#  starts_at   :datetime         not null
#  ends_at     :datetime         not null
#  location    :string           not null
#  created_at  :datetime
#  updated_at  :datetime
#

require 'spec_helper'

describe Event do
  context 'validations' do
    it { should validate_presence_of(:internal) }
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:starts_at) }
    it { should validate_presence_of(:ends_at) }
    it { should validate_presence_of(:location) }

    it { should have_many(:user_events) }
    it { should have_many(:users) }
    it { should have_many(:participants) }
  end

  context 'participantions' do
    let(:user) { create :user }
    let(:event_with_participation) { create :event, participants: [user] }
    let(:event_with_declined_participation) { create :event, users: [user] }
    let(:event_without_participation) { create :event }

    it { expect(event_with_participation.participants).to include user }
    it { expect(event_with_declined_participation.participants).not_to include user }
    it { expect(event_without_participation.participants).not_to include user }
  end

  context 'empty end date' do
    let(:event) { create :event, ends_at: nil }
    it { expect(event.ends_at).to eq event.starts_at }
  end
end
