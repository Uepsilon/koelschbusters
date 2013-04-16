require "cancan/matchers"
require 'spec_helper'

describe User do
  describe "attributes" do
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
    let(:future_news)       { create(:news, :published_in_future) }

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
      it{ should_not be_able_to(:read, future_news)}
    end

    context "when is a guest" do
      it{ should_not be_able_to(:manage, User)}
      it{ should_not be_able_to(:edit, user)}

      # read news
      it{ should_not be_able_to(:manage, News)}
      it{ should be_able_to(:read, news)}

      it{ should_not be_able_to(:read, private_news)}
      it{ should_not be_able_to(:read, unpublished_news)}
      it{ should_not be_able_to(:read, future_news)}
    end
  end
end
