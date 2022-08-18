# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy delete_profile]
  before_action :user_contact, only: %i[edit]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
    redirect_to '/home'
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit; end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to sessions_path(email: @user.email, password: @user.password_digest), notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end

    p "======================================================"
    p @user
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    if params[:profile_pic].nil?
      respond_to do |format|
        if @user.update(name: params[:name])
          format.html { redirect_to '/settings', notice: 'User was successfully updated.' }
          format.json { render :show, status: :ok, location: @user }

        else
          format.html { redirect_to '/settings', status: :unprocessable_entity }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        if @user.update(name: params[:name], profile_pic: params[:profile_pic])
          format.html { redirect_to '/settings', notice: 'User was successfully updated.' }
          format.json { render :show, status: :ok, location: @user }

        else
          format.html { redirect_to '/settings', status: :unprocessable_entity }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def delete_profile
    @user.profile_pic.purge
    redirect_to '/settings'
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(current_user.id) if current_user
  end

  def user_contact
    @usercontact = UserContact.all
    if @usercontact.present? && current_user
      @usercontacts = UserContact.find_by_user_id(current_user.id)
      if @usercontacts.present?
        @usermobile = @usercontacts.mobile
        @userwebsite = @usercontacts.website
        @userlinkedin = @usercontacts.linkedin
        @userbehance = @usercontacts.behance
        @usergithub = @usercontacts.github
        @userinstagram = @usercontacts.instagram
      end
    end
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
