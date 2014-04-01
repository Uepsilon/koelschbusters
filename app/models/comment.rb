class Comment < ActiveRecord::Base
  belongs_to  :news
  belongs_to  :user

  scope :inactive, where(activated_at: nil)

  default_scope order("created_at DESC")

  validates :username,  presence: true, if: :guest_comment
  validates :user_id,   presence: true, unless: :guest_comment

  validates :body,      presence: true
  validates :news_id,   presence: true

  attr_accessible :body, :username, :news_id, :user_id

  before_save :activate, unless: :guest_comment

  def guest_comment
    self.user_id.nil?
  end

  def active?
    not self.activated_at.nil? and self.activated_at <= DateTime.now
  end

  def activate
    self.activated_at = DateTime.now
  end

  def activate!
    self.activate
    self.save!
  end

  def deactivate!
    self.activated_at = nil
    self.save!
  end

  def self.team_reminder
    if self.inactive.count > 0
      User.where(role: [:admin, :management]).each do |user|
        TeamMailer.comment_reminder(user, self.inactive.count).deliver
      end
    end
  end
end
