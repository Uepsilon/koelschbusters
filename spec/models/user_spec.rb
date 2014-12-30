# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  first_name             :string(255)      default(""), not null
#  last_name              :string(255)      default(""), not null
#  street                 :string(255)
#  houseno                :string(255)
#  zipcode                :string(255)
#  city                   :string(255)
#  phone                  :string(255)
#  mobile                 :string(255)
#  member_active          :boolean          default(FALSE)
#  role                   :string(255)      default("member"), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  twitter_uid            :string(255)
#  twitter_name           :string(255)
#  facebook_uid           :string(255)
#  facebook_name          :string(255)
#  google_uid             :string(255)
#  google_name            :string(255)
#

require 'cancan/matchers'
require 'spec_helper'

describe User do
  describe 'Validation' do
    it 'has a valid factory' do
      create(:user).should be_valid
    end

    it 'is invalid without an email' do
      # subject { create(:user, email: nil) }

      subject.should be_invalid
      subject.errors.should include(:email)
    end

    it 'is invalid without first_name' do
      # subject { create(:user, first_name: nil) }

      subject.should be_invalid
      subject.errors.should include(:first_name)
    end

    it 'is invalid without last_name' do
      # subject { create(:user, last_name: nil) }

      subject.should be_invalid
      subject.errors.should include(:last_name)
    end

    it 'is invalid without an email_confirmation when email changes' do
      user = create(:user)
      user.update_attributes(email: 'email@changed.com', email_confirmation: '')

      user.should be_invalid
      user.errors.should include(:email)
    end

    it 'is invalid without a password_confirmation when password changes' do
      user = create(:user)
      user.update_attributes(password: 'NewPassword123')

      user.should be_invalid
      user.errors.should include(:password_confirmation)
    end

    it 'is invalid without a role' do
      user = build(:user, role: nil)

      user.should be_invalid
      user.errors.should include(:role)
    end

    it 'is invalid with a non numerical phone' do
      user = build(:user, phone: 'Abc')

      user.should be_invalid
      user.errors.should include(:phone)
    end

    it 'is valid without a numerical phone' do
      user = build(:user, phone: nil)

      user.should be_valid
    end

    it 'is invalid with a non numerical mobile' do
      user = build(:user, mobile: 'Abc')

      user.should be_invalid
      user.errors.should include(:mobile)
    end

    it 'is valid without a mobile' do
      user = build(:user, mobile: nil)

      user.should be_valid
    end

    it 'is invalid with a non numerical zip-code' do
      user = build(:user, zipcode: 'Abc')

      user.should be_invalid
      user.errors.should include(:zipcode)
    end

    it 'is invalid with a too short zip-code' do
      user = build(:user, zipcode: 1234)

      user.should be_invalid
      user.errors.should include(:zipcode)
    end

    it 'is invalid with a too long zip-code' do
      user = build(:user, zipcode: 123_456)

      user.should be_invalid
      user.errors.should include(:zipcode)
    end
  end

  describe 'Attributes' do
    let(:user) { create(:user) }

    it 'name returns combined name' do
      user.name.should eq("#{user.first_name} #{user.last_name}")
    end

    it 'email should require confirmation on change' do
      user.email                = 'TestEmailAddress@Example.com'
      user.email_confirmation   = ''
      user.skip_reconfirmation!
      user.save

      user.should_not be_valid
      user.errors.should include(:email)

      user.email_confirmation   = 'TestEmailAddress@Example.com'
      user.skip_reconfirmation!
      user.save

      user.should be_valid
      user.errors.should be_empty
    end

    it 'email should be always be lower case' do
      user.email              = 'TestEmailAddress@Example.com'
      user.email_confirmation = 'TestEmailAddress@Example.com'
      user.skip_reconfirmation!
      user.save

      user.email.should eq('testemailaddress@example.com')
    end

    it 'password should require confirmation on change' do
      user.password = 'NewPassword123!'
      user.save

      user.should_not be_valid
      user.errors.should include(:password_confirmation)
    end
  end

  describe '#role?' do
    context 'when role is member' do
      subject { create(:user) }

      it { subject.role?(:member).should be_true }
      it { subject.role?(:management).should be_false }
      it { subject.role?(:admin).should be_false }
    end

    context 'when role is management' do
      subject { create(:user, :management) }

      it { subject.role?(:member).should be_true }
      it { subject.role?(:management).should be_true }
      it { subject.role?(:admin).should be_false }
    end

    context 'when role is admin' do
      subject { create(:user, :admin) }

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

    context 'when is an admin' do
      let(:user) { create(:user, :admin) }

      # manage users
      it { should be_able_to(:manage, User) }

      # manage news
      it { should be_able_to(:manage, News) }

      it { should be_able_to(:access, :admin) }
    end

    context 'when is a management' do
      let(:user) { create(:user, :management) }

      # manage users
      it { should be_able_to(:manage, User) }

      # manage news
      it { should be_able_to(:manage, News) }
      it { should be_able_to(:manage, news) }

      it { should be_able_to(:access, :admin) }
    end

    context 'when is an user' do
      let(:user) { create(:user) }

      # manage users
      it { should_not be_able_to(:manage, User) }
      it { should be_able_to(:edit, user) }

      # read news
      it { should_not be_able_to(:manage, News) }
      it { should be_able_to(:read, news) }
      it { should be_able_to(:read, private_news) }

      it { should_not be_able_to(:read, unpublished_news) }
      it { should_not be_able_to(:read, upcoming_news) }
    end

    context 'when is a guest' do
      it { should_not be_able_to(:manage, User) }
      it { should_not be_able_to(:edit, user) }

      # read news
      it { should_not be_able_to(:manage, News) }
      it { should be_able_to(:read, news) }

      it { should_not be_able_to(:read, private_news) }
      it { should_not be_able_to(:read, unpublished_news) }
      it { should_not be_able_to(:read, upcoming_news) }
    end
  end
end
