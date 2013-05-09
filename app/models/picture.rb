class Picture < ActiveRecord::Base
  belongs_to :gallery

  has_attached_file :picture,
                    :default_style => :fullscreen,
                    :url  => "/pictures/:id/:style",
                    :path => ":rails_root/shared/pictures/:id/:style_:basename.:extension",
                    :styles => { :content => '800>', :thumb => '118x100#' }

  attr_accessible :internal, :picture

  validates_attachment_size :picture, :less_than => 5.megabytes
  validates_attachment_presence :picture
end
