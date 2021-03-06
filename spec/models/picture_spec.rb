# == Schema Information
#
# Table name: pictures
#
#  id                   :integer          not null, primary key
#  internal             :boolean
#  gallery_id           :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  picture_file_name    :string(255)
#  picture_content_type :string(255)
#  picture_file_size    :integer
#  picture_updated_at   :datetime
#  position             :integer
#

require 'spec_helper'

describe Picture do
  before(:each) { Picture.destroy_all }

  describe 'Validations' do
    it 'has a valid factory' do
      create(:picture).should be_valid
    end

    it 'should be invalid without a picture' do
      should validate_presence_of :picture
    end

    it 'should be invalid with a picture > 5MB' do
      picture = build(:oversized_picture)
      picture.should be_invalid
      picture.errors.should include :picture_file_size
    end
  end

  describe 'public?' do
    let(:picture) { create(:picture) }
    let(:published_picture) { create(:public_picture) }

    it { picture.public?.should be false }
    it { published_picture.public?.should be true }
  end

  describe 'publish' do
    let(:picture) { create(:picture) }

    it 'should be public after publishing' do
      picture.public?.should be false
      picture.publish
      picture.public?.should be true
    end
  end

  describe 'unpublish' do
    let(:picture) { create(:public_picture) }

    it 'should be public after publishing' do
      picture.public?.should be true
      picture.unpublish
      picture.public?.should be false
    end
  end
end
