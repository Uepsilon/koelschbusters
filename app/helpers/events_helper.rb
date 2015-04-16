module EventsHelper
  def event_row_class(event)
    if event.in? @current_user.participating_events
      :success
    elsif event.in? @current_user.declined_events
      :danger
    end
  end
end
