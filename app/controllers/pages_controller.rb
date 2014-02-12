class PagesController < ApplicationController

  def index
  end

  def imprint
  end

  def about
    @contact = Contact.new
  end

  def contact
    @contact = Contact.new params[:contact]

    if @contact.valid?
      ContactMailer.contact_email(@contact).deliver
      flash[:notice] = "Vielen Dank für Ihre Nachricht."
      redirect_to :about
    else
      render :about
    end
  end
end
