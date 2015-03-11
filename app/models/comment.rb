# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  username         :string(255)
#  body             :text
#  user_id          :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  activated_at     :datetime
#  commentable_id   :integer
#  commentable_type :string(255)
#

class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  scope :inactive, -> { where activated_at: nil }

  default_scope -> { order created_at: :desc }

  validates :username, presence: true, if: :guest_comment
  validates :user_id, presence: true, unless: :guest_comment

  validates :body, presence: true
  validates :commentable_id, presence: true

  before_create :activate, unless: :guest_comment

  def guest_comment
    user_id.nil?
  end

  def active?
    activated_at.present? && activated_at <= Time.now
  end

  def activate
    self.activated_at = Time.now
  end

  def activate!
    activate
    save!
  end

  def deactivate!
    self.activated_at = nil
    save!
  end

  def self.team_reminder
    if inactive.count > 0
      User.where(role: [:admin, :management]).each do |user|
        TeamMailer.comment_reminder(user, inactive.count).deliver_now
      end
    end
  end
end
