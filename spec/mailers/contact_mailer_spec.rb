require 'spec_helper'

describe ContactMailer do
  describe 'contact_mailer' do
    let(:contact) { build :contact }
    let(:mail) { ContactMailer.contact_email(contact) }

    it { mail.from.should include(Rails.application.secrets.noreply_email) }
    it { mail.to.should include(Rails.application.secrets.contact_email) }
    it { mail.subject.should eq('Spec Test Subject') }
    it { mail.subject.should eq('Spec Test Subject') }
    it { mail.body.encoded.should include('Name: Spec Test') }
    it { mail.body.encoded.should include('E-Mail: spec@example.com') }
    it { mail.body.encoded.should include('Lorem Ipsum') }
  end
end
