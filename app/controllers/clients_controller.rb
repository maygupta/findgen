class ClientsController < ApplicationController

  def index
    respond_to do |format|
      format.html
      format.json { render json: Client.all, status: 201 }
    end
  end

  def create
    Client.create(params.require(:client).permit(:name,:location,:email))
    render json: Client.all, status: 201 
  end

  def show
    @current_client = Client.find(params[:id])

    unpaid_bookings = Booking.where(:client_id => params[:id], :status => "completed")
    cost = 0
    unpaid_bookings.each {|x| cost += x.cost}
    @current_client.balance = cost
    @current_client.save

    @bookings = Booking.where(:client_id => params[:id])

    status = params[:booking_status].nil? ? "approved" : params[:booking_status]

    @bookings = @bookings.where(:status => status)

    if current_user.is_spoc?
      @bookings = @bookings.where(:user_id => current_user.id)
    end
  end
end
