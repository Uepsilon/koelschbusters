require 'spec_helper'

describe Category do
  subject { create(:category) }
  describe "Validation" do
    it "has a valid factory" do
      subject.should be_valid
    end

    it { should validate_presence_of(:title) }
    it { should validate_uniqueness_of(:title) }
  end
end
