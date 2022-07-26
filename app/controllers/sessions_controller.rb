# frozen_string_literal: true

class SessionsController < ApplicationController
  @@user
  @@useremail = {}


  def create
    
    user = User.find_by_email(params[:email])
    if user&.authenticate(params[:password]) || !user.nil?&&user.password_digest == params[:password]
      session[:user_id] = user.id
      redirect_to '/home', notice: 'Logged in!'
    else
      flash.now[:alert] = 'Email or password is invalid'
      render 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to '/login', notice: 'Logged out!'
  end


  def forgot_password
    if params[:email] != ''
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
  end

  def resend
    ForgotMailer.with(user: @@user).forgot_password.deliver_later
    redirect_to '/reset'
  end


  def password_reset
    if params[:code] != ''
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


  def set_password
    if !update_params[:password].nil? || !update_params[:password_confirmation].nil?
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

  private

  def update_params
    params.require(:set).permit(:password, :password_confirmation)
  end
end
