class EventParticipationsController < ApplicationController
  authorize_resource :event
  authorize_resource :user_event

  before_action :load_resources

  def create
    @current_user.user_events.create event: @event, participation: params[:participation]
    redirect_to @event
  end

  def update
    @user_event.update participation: params[:participation]
    redirect_to @event
  end

  private

  def load_resources
    @event = Event.find params[:event_id]
    @user_event = UserEvent.find_by user_id: @current_user.id, event_id: @event.id
  end
end
