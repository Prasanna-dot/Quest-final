# frozen_string_literal: true

class SessionsController < ApplicationController
  @@user
  @@useremail = {}
  def new; end

  def create
    user = User.find_by_email(params[:email])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to '/login', notice: 'Logged in!'
    else
      flash.now[:alert] = 'Email or password is invalid'
      render 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to '/login', notice: 'Logged out!'
  end

  def forgot; end

  def forgot_password
    @@user = User.find_by_email(params[:email])
    @@useremail[:userid] = @@user.id
    if @@user
      ForgotMailer.with(user: @@user).forgot_password.deliver_later
      redirect_to '/reset'
    else
      flash.now[:alert] = 'Email is invalid'
      render 'forgot'
    end
  end

  def resend
    ForgotMailer.with(user: @@user).forgot_password.deliver_later
    redirect_to '/reset'
  end

  def reset; end

  def password_reset
    if $pin == params[:code]
      flash.now[:alert] = 'Code is invalid'
      redirect_to '/reset_password'
    else
      render 'reset'
    end
  end

  def reset_password; end

  def set_password
    @us = User.find_by_id(@@useremail[:userid])
    if update_params[:password] == update_params[:password_confirmation]
      @us.update(update_params)
      redirect_to '/login'
    else
      flash.now[:alert] = 'Passwords are not same'
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
end
