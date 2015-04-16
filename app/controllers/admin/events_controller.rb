class Admin::EventsController < Admin::ApplicationController
  load_and_authorize_resource

  add_breadcrumb I18n.t('breadcrumbs.events'), [:admin, :events]

  def index
    @events = EventDecorator.decorate_collection @events
  end

  def show
    @event = @event.decorate
  end

  def new
    add_breadcrumb I18n.t('breadcrumbs.new'), new_admin_event_path
  end

  def create
    add_breadcrumb I18n.t('breadcrumbs.new'), new_admin_event_path

    if @event.save
      redirect_to :admin_events
    else
      render :new
    end
  end

  def edit
    add_breadcrumb I18n.t('breadcrumbs.edit'), [:edit, :admin, @event]
  end

  def update
    add_breadcrumb I18n.t('breadcrumbs.edit'), [:edit, :admin, @event]

    if @event.update event_params
      redirect_to :admin_events
    else
      render :edit
    end
  end

  def destroy
    @event.delete

    redirect_to :admin_events
  end

  private

  def event_params
    params.require(:event).permit(:internal, :title, :description, :starts_at, :ends_at, :location)
  end
end
