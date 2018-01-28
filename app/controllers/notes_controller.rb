class NotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_note, only: [:show, :edit, :update, :destroy, :check_tag, :check_auth, :share]
  before_action :check_auth, only: [:edit, :update]

  require 'json'
  
  # GET /notes
  # GET /notes.json
  def index
    @notes = current_user.notes
    @shared_notes = Note.with_roles([:guest, :moderator, :owner], current_user).uniq
  end

  # GET /notes/1
  # GET /notes/1.json
  def show
    # List non admin users for share
    @moderator =  current_user.has_role? :moderator, @note
    @owner = current_user.has_role? :owner, @note
    @guest = current_user.has_role? :guest, @note

    if (@moderator || @owner || @guest)
      @users = User.without_role(:admin)    
    else
      redirect_back fallback_location: "/", alert: "This note is not shared with you"
    end
  end

  def search
    tag = Tag.find_by(tag_name: params[:tag])
     respond_to do |format|
      format.json { render json: tag.notes }
    end
  end

  def share
    if params[:commit] == "Share"
      user = User.find(params[:user])
      if params[:read]
        user.add_role :guest, @note 
      end
      if params[:update]
        user.add_role :moderator, @note
      end
      if params[:owner]
        user.add_role :owner, @note
      end
      redirect_back fallback_location: "/", notice: "Shared"
    
    elsif params[:commit] == "Revoke" 
      user = User.find(params[:user])
      if (current_user.has_role? :owner, @note)
        if params[:read].nil?
          user.remove_role :guest, @note 
        end
        if params[:update].nil?
          user.remove_role :moderator, @note
        end
        if params[:owner].nil?
          user.remove_role :owner, @note
        end
        redirect_back fallback_location: "/", notice: "Share removed"
      else
        redirect_back fallback_location: "/", alert: "Access Revoke can only be done by owner of note"
      end
    end
  end


  # GET /notes/new
  def new
    @note = Note.new
    @tags = Tag.all
  end

  # GET /notes/1/edit
  def edit
    @tags = Tag.all
    @note_tags =  []
    @note.tags.each do |tag|
      @note_tags.push(tag.tag_name)
    end
  end

  def check_tag
    if !params[:tags].nil?
      tags_arr = params[:tags]
      tags_arr.each do |tag|
        tag_obj = Tag.find_by(tag_name: tag)
        if tag_obj.nil?
         tag_new = Tag.new
         tag_new.tag_name = tag
         tag_new.save
         @note.tags << tag_new unless @note.tags.include?(tag_new)
         tag_new.notes << @note unless tag_new.notes.include?(@note)
        else
          @note.tags << tag_obj unless @note.tags.include?(tag_obj)
          tag_obj.notes << @note unless tag_obj.notes.include?(@note)
          tag_obj.save
        end
      end
    # binding.pry
    end
  end

  # POST /notes
  # POST /notes.json
  def create
    @note = Note.new(note_params)
    @note.user = current_user

    respond_to do |format|
      if @note.save
        # Check for tags
        current_user.add_role :owner, @note
        check_tag
        format.html { redirect_to @note, notice: 'Note was successfully created.' }
        format.json { render :show, status: :created, location: @note }
      else
        format.html { render :new }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /notes/1
  # PATCH/PUT /notes/1.json
  def update
    respond_to do |format|
      if @note.update(note_params)
        # Check for tags
        check_tag        
        format.html { redirect_to @note, notice: 'Note was successfully updated.' }
        format.json { render :show, status: :ok, location: @note }
      else
        format.html { render :edit }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notes/1
  # DELETE /notes/1.json
  def destroy
    @note.destroy
    respond_to do |format|
      format.html { redirect_to notes_url, notice: 'Note was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note
      @note = Note.find(params[:id])
    end

    def check_auth
      # ability = Ability.new(current_user, @note)
      if !((current_user.has_role? :moderator, @note) || (current_user.has_role? :owner, @note))
        redirect_back fallback_location: "/", alert: "Not allowed"
      end
      # binding.pry
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def note_params
      # White list tag parameter
      params.require(:note).permit(:content, :user_id)
    end
end
