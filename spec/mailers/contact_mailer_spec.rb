require "spec_helper"

describe ContactMailer do
  describe "contact_mailer" do
    let(:contact) { mock_model Contact, email: "spec@example.com", name: "Spec Test", subject: "Spec Test Subject", text: "Lorem  Ipsum"}
    let(:mail) { ContactMailer.contact_email(contact) }

    it {  mail.from.should include(Figaro.env.noreply_email) }
    it {  mail.to.should include(Figaro.env.contact_email) }
    it {  mail.subject.should eq("Spec Test Subject") }
    it {  mail.subject.should eq("Spec Test Subject") }
  end
end
