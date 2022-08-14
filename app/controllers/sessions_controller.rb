# frozen_string_literal: true

class SessionsController < ApplicationController
  @@user
  @@useremail = {}
  
  def new; end

  def create
    user = User.find_by_email(params[:email])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to '/home', notice: 'Logged in!'
    else
      flash.now[:alert] = 'Email or password is invalid'
      render 'new'
    end

    if user = authenticate_via_google
      cookies.signed[:user_id] = user.id
      redirect_to user
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to '/login', notice: 'Logged out!'
  end

  def forgot; end

  def forgot_password
    if params[:email] != ""
      @@user = User.find_by_email(params[:email])
    if @@user.present?
      @@useremail[:userid] = @@user.id
      ForgotMailer.with(user: @@user).forgot_password.deliver_later
      redirect_to '/reset'
    else
      flash.now[:alert] = 'Email is invalid'
      render 'forgot'
    end
  else
    flash.now[:alert] = 'Please fill your email'
    render 'forgot'
  end

    p "========================================================"
    p params[:email]
  end

  def resend
    ForgotMailer.with(user: @@user).forgot_password.deliver_later
    redirect_to '/reset'
  end

  def reset; end

  def password_reset
    if params[:code] != ""
      if $pin == params[:code]
        redirect_to '/reset_password'
      else
        flash.now[:alert] = 'Code is invalid'
        render 'reset'
      end
    else
      flash.now[:alert] = 'Please enter your code'
      render 'reset'
    end
  end

  def reset_password; end

  def set_password
    if update_params[:password] != nil || update_params[:password_confirmation] != nil
    @us = User.find_by_id(@@useremail[:userid])
      if update_params[:password] == update_params[:password_confirmation]
        @us.update(update_params)
        redirect_to '/login'
      else
        flash.now[:alert] = 'Passwords are not same'
        render 'reset_password'
      end
    else
      flash.now[:alert] = 'Please fill your new password'
      render 'reset_password'
    end
  end

  def omniauth
    binding.pry
  end

  private

  def update_params
    params.require(:set).permit(:password, :password_confirmation)
  end

  def authenticate_via_google
    if params[:google_id_token].present?
      User.find_by google_id: GoogleSignIn::Identity.new(params[:google_id_token]).user_id
    end
  end
end
