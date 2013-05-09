require 'spec_helper'

describe Picture do
  before(:each) { Picture.destroy_all }

  describe "Validations" do
    it "has a valid factory" do
      pic = create(:picture).should be_valid
    end

    it "should be invalid without a picture" do
      should validate_presence_of :picture
    end

    it "should be invalid with a picture > 5MB" do
      picture = build(:picture, :oversized)
      picture.should be_invalid
      picture.errors.should include :picture_file_size
    end
  end
end
