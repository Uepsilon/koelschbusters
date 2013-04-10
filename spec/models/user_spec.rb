require 'spec_helper'

describe User do
  it "name returns combined name" do
    user = create(:user)

    user.name.should eq("#{user.first_name} #{user.last_name}")
  end

  it "email should require confirmation on change" do
    user = create(:user)

    user.email              = 'TestEmailAddress@Example.com'
    user.save

    user.should_not be_valid
    user.errors.should include(:email_confirmation)

    user.email_confirmation = 'TestEmailAddress@Example.com'
    user.save

    user.should be_valid
    user.errors.should be_empty
  end

  it "email should save without errors when email confirmed" do
    user = create(:user)

    user.email              = 'TestEmailAddress@Example.com'
    user.email_confirmation = 'TestEmailAddress@Example.com'
    user.save

    user.should be_valid
    user.errors.should be_empty
    user.email.should eq('testemailaddress@example.com')
  end

  it "email should be always be lower case" do
    user = create(:user)

    user.email              = 'TestEmailAddress@Example.com'
    user.email_confirmation = 'TestEmailAddress@Example.com'
    user.save

    user.email.should eq('testemailaddress@example.com')
  end

  it "password should require confirmation on change" do
    user = create(:user)

    user.password = 'NewPassword123!'
    user.save

    user.should_not be_valid
    user.errors.should include(:password_confirmation)
  end

  it "password should change when confirmed" do
    user = create(:user)

    user.password = 'NewPassword123!'
    user.password_confirmation = 'NewPassword123!'
    user.save

    user.should be_valid
    user.errors.should be_empty
  end

  describe "Roles" do

    it "user should have role member" do
      user = create(:user)

      user.role?(:member).should be_true
    end

    it "user should not have any other role" do
      user = create(:user)

      user.role?(:management).should be_false
      user.role?(:admin).should be_false
    end

    it "manager should have role management" do
      manager = create(:user, :manager)

      manager.role?(:management).should be_true
    end

    it "manager should have role member" do
      manager = create(:user, :manager)

      manager.role?(:member).should be_true
    end

    it "manager should not have admin role" do
      manager = create(:user, :manager)

      manager.role?(:admin).should be_false
    end

    it "admin should have role admin" do
      admin = create(:user, :admin)

      admin.role?(:admin).should be_true
    end

    it "admin should have all other roles" do
      admin = create(:user, :admin)

      admin.role?(:management).should be_true
      admin.role?(:member).should be_true
    end
  end
end
