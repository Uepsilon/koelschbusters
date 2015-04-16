class EventDecorator < Draper::Decorator
  delegate_all

  def end_date
    h.l object.ends_at, format: :short unless object.ends_at == object.starts_at
  end

  def start_date
    h.l object.starts_at, format: :short
  end
end
