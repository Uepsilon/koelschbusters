class EventsController < ApplicationController
  load_and_authorize_resource

  def index
    @events = EventDecorator.decorate_collection @events
  end

  def show
    @event = @event.decorate
    @comment = @event.comments.new
  end
end
