require 'spec_helper'

RSpec.describe EventMailer, type: :mailer do
  let!(:user) { create :user }
  let!(:event) { create :event }
  let!(:mail) { ActionMailer::Base.deliveries.last }

  before do
    create_list :user, 3
  end

  it { expect { create :event }.to change { ActionMailer::Base.deliveries.count }.by(User.count) }
  it { expect(mail).to_not be_nil }
  it { expect(mail.from).to include Rails.application.secrets.noreply_email }
  it { expect(mail.subject).to eq 'Ein neuer Termin wurde eingestellt' }
  it { expect(mail.body.encoded).to include user.first_name }
  it { expect(mail.body.encoded).to include url_for(controller: :events, action: :show, id: event.id) }
end
