# encoding: UTF-8
class ContactsController < ApplicationController
  load_and_authorize_resource

  def new
  end

  def create
    @contact = Contact.new params[:contact]

    if @contact.valid?
      ContactMailer.contact_email(@contact).deliver
      flash[:notice] = "Vielen Dank für Ihre Nachricht."
      redirect_to :contact
    else
      render :new
    end
  end
end
