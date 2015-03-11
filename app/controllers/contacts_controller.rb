# encoding: UTF-8
class ContactsController < ApplicationController
  load_and_authorize_resource

  def create
    @contact = Contact.new params[:contact]

    if @contact.valid?
      @contact.send_mail
      flash[:notice] = 'Vielen Dank für Ihre Nachricht.'
      redirect_to :contact
    else
      render :new
    end
  end
end
