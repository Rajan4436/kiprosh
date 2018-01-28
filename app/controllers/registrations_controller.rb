class RegistrationsController < Devise::RegistrationsController
	after_action :associate_user, only: :create

	protected

		# this will run after creating user 
		def associate_user
			# Check for persistence of user record just created
			if resource.persisted?
				# set up to default role to user
				# resource.add_role :guest
			end
		end

end	