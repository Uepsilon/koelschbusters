require "cancan/matchers"
require 'spec_helper'

describe User do
  describe "Validation" do
    it "has a valid factory" do
      create(:user).should be_valid
    end

    it "is invalid without an email" do
      # subject { create(:user, email: nil) }

      subject.should be_invalid
      subject.errors.should include(:email)
    end

    it "is invalid without first_name" do
      # subject { create(:user, first_name: nil) }

      subject.should be_invalid
      subject.errors.should include(:first_name)
    end

    it "is invalid without last_name" do
      # subject { create(:user, last_name: nil) }

      subject.should be_invalid
      subject.errors.should include(:last_name)
    end

    it "is invalid without an email_confirmation when email changes" do
      user = create(:user)
      user.update_attributes(email: "email@changed.com")

      user.should be_invalid
      user.errors.should include(:email_confirmation)
    end

    it "is invalid without a password_confirmation when password changes" do
      user = create(:user)
      user.update_attributes(password: "NewPassword123")

      user.should be_invalid
      user.errors.should include(:password_confirmation)
    end

    it "is invalid without a role" do
      user = build(:user, role: nil)

      user.should be_invalid
      user.errors.should include(:role)
    end

    it "is invalid with a non numerical phone" do
      user = build(:user, phone: "Abc")

      user.should be_invalid
      user.errors.should include(:phone)
    end

    it "is valid without a numerical phone" do
      user = build(:user, phone: nil)

      user.should be_valid
    end

    it "is invalid with a non numerical mobile" do
      user = build(:user, mobile: "Abc")

      user.should be_invalid
      user.errors.should include(:mobile)
    end

    it "is valid without a mobile" do
      user = build(:user, mobile: nil)

      user.should be_valid
    end

    it "is invalid with a non numerical zip-code" do
      user = build(:user, zipcode: "Abc")

      user.should be_invalid
      user.errors.should include(:zipcode)
    end

    it "is invalid with a too short zip-code" do
      user = build(:user, zipcode: 1234)

      user.should be_invalid
      user.errors.should include(:zipcode)
    end

    it "is invalid with a too long zip-code" do
      user = build(:user, zipcode: 123456)

      user.should be_invalid
      user.errors.should include(:zipcode)
    end
  end

  describe "Attributes" do
    let(:user) { create(:user) }

    it "name returns combined name" do
      user.name.should eq("#{user.first_name} #{user.last_name}")
    end

    it "email should require confirmation on change" do
      user.email              = 'TestEmailAddress@Example.com'
      user.save

      user.should_not be_valid
      user.errors.should include(:email_confirmation)

      user.email_confirmation = 'TestEmailAddress@Example.com'
      user.save

      user.should be_valid
      user.errors.should be_empty
    end

    it "email should be always be lower case" do
      user.email              = 'TestEmailAddress@Example.com'
      user.email_confirmation = 'TestEmailAddress@Example.com'
      user.save

      user.email.should eq('testemailaddress@example.com')
    end

    it "password should require confirmation on change" do
      user.password = 'NewPassword123!'
      user.save

      user.should_not be_valid
      user.errors.should include(:password_confirmation)
    end
  end

  describe "#role?" do
    context 'when role is member' do
      subject {create(:user)}

      it { subject.role?(:member).should be_true }
      it { subject.role?(:management).should be_false }
      it { subject.role?(:admin).should be_false }
    end

    context 'when role is management' do
      subject {create(:user, :manager)}

      it { subject.role?(:member).should be_true }
      it { subject.role?(:management).should be_true }
      it { subject.role?(:admin).should be_false }
    end

    context 'when role is admin' do
      subject {create(:user, :admin)}

      it { subject.role?(:member).should be_true }
      it { subject.role?(:management).should be_true }
      it { subject.role?(:admin).should be_true }
    end
  end

  describe 'Abilities' do
    subject       { ability }
    let(:ability) { Ability.new(user) }
    let(:user)    { nil }

    # news
    let(:news)              { create(:news) }
    let(:private_news)      { create(:news, :members_only) }
    let(:unpublished_news)  { create(:news, :unpublished) }
    let(:upcoming_news)     { create(:news, :upcoming) }

    context "when is an admin" do
      let(:user){ create(:user, :admin) }

      # manage users
      it{ should be_able_to(:manage, User) }

      # manage news
      it{ should be_able_to(:manage, News) }

      it{ should be_able_to(:access, :admin) }
    end

    context "when is a manager" do
      let(:user){ create(:user, :manager) }

      # manage users
      it{ should be_able_to(:manage, User) }

      # manage news
      it{ should be_able_to(:manage, News) }
      it{ should be_able_to(:manage, news) }

      it{ should be_able_to(:access, :admin) }
    end

    context "when is an user" do
      let(:user) { create(:user) }

      # manage users
      it{ should_not be_able_to(:manage, User) }
      it{ should be_able_to(:edit, user) }

      # read news
      it{ should_not be_able_to(:manage, News)}
      it{ should be_able_to(:read, news)}
      it{ should be_able_to(:read, private_news)}

      it{ should_not be_able_to(:read, unpublished_news)}
      it{ should_not be_able_to(:read, upcoming_news)}
    end

    context "when is a guest" do
      it{ should_not be_able_to(:manage, User)}
      it{ should_not be_able_to(:edit, user)}

      # read news
      it{ should_not be_able_to(:manage, News)}
      it{ should be_able_to(:read, news)}

      it{ should_not be_able_to(:read, private_news)}
      it{ should_not be_able_to(:read, unpublished_news)}
      it{ should_not be_able_to(:read, upcoming_news)}
    end
  end
end
