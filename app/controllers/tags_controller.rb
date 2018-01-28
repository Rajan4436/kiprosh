class TagsController < ApplicationController

	def index
		
	end

	def remove
		tag = Tag.find_by(secret_name: params[:tag_name])
		 # tag.id
		# tag
	end
end
