class Booking < ActiveRecord::Base

	belongs_to :user
	belongs_to :client

end