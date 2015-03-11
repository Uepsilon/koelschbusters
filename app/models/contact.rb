class Contact
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  extend ActiveModel::Translation

  class << self
    def i18n_scope
      :activerecord
    end
  end

  attr_accessor :email, :name, :subject, :text

  validates :name, presence: true
  validates :text, presence: true

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def send_mail
    ContactMailer.contact_email(self).deliver_now
  end

  def persisted?
    false
  end
end
