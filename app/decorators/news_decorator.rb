class NewsDecorator < ApplicationDecorator
  delegate_all

  def comment_count(current_ability)
    object.comments.accessible_by(current_ability).count
  end
end
