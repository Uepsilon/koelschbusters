class NewsComment < ActiveRecord::Base
  belongs_to  :news
  belongs_to  :user

  scope :inactive, where(activated_at: nil)

  default_scope order("created_at DESC")

  validates :username,  presence: true, :if     => :guest_comment
  validates :email,     presence: true, :if     => :guest_comment

  validates :user_id,   presence: true, :unless => :guest_comment

  validates :body,      presence: true
  validates :news_id,   presence: true

  attr_accessible :body, :username, :email, :news_id, :user_id

  def guest_comment
    self.user_id.nil?
  end

  def active?
    not self.activated_at.nil? and self.activated_at <= DateTime.now.utc
  end

  def activate
    self.activated_at = DateTime.now.utc
  end
end
