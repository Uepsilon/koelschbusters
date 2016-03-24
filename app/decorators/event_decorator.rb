class EventDecorator < Draper::Decorator
  delegate_all

  def end_date
    h.l object.ends_at, format: '%d.%m.%Y %H:%M Uhr' unless object.ends_at == object.starts_at
  end

  def start_date
    h.l object.starts_at, format: '%d.%m.%Y %H:%M Uhr'
  end
end
