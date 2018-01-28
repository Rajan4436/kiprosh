class HomeController < ApplicationController
  before_action :authenticate_owner
  def index
  end

  protected

		# Authenticate only admin to this controller actions
		def authenticate_owner
  		if user_signed_in? 
        if !(current_user.has_role? :owner) 
	  	    redirect_to "/notes"
	  	    return
        end
      else
          redirect_to "/users/sign_in"
	  	    return
  		end
  	end
end
