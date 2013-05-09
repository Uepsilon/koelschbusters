require 'spec_helper'

describe Gallery do
  # Cleanup mess after test
  after(:each) { Gallery.destroy_all }
  after(:each) { Picture.destroy_all }

  describe "Validations" do
    it "should be invalid without a title" do
      subject.should_not be_valid
      subject.errors.should include :title
    end

    it "should be valid with a title" do
      gallery = Gallery.create title: "Some Title"
      gallery.should be_valid
    end
  end

  describe "Scopes" do
    let!(:gallery_with_pictures) { create :gallery_with_pictures }
    let!(:gallery_without_pictures) { create :gallery }
    it "returns gallery with all pictures " do

      galleries = Gallery.with_pictures.all

      galleries.should include gallery_with_pictures
      galleries.should_not include gallery_without_pictures
    end

    it "return gallery with internal pictures" do
      galleries = Gallery.with_public_pictures.all

      galleries.should include gallery_with_pictures
      galleries.each do |gallery|
        gallery.public_pictures.each do |picture|
          picture.internal.should_not be_true
        end
      end
    end
  end
end
