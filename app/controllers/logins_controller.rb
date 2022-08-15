# frozen_string_literal: true

class LoginsController < ApplicationController
  def new; end

  def create
    user = User.all
    if user = authenticate_with_google
      cookies.signed[:user_id] = user.id
      redirect_to user
    else
      redirect_to new_session_url, alert: 'authentication_failed'
    end

    p '==============================================================='
    p flash[:google_sign_in][:id_token]
  end

  private

  def authenticate_with_google
    if id_token = flash[:google_sign_in][:id_token]
      User.find(google_id: GoogleSignIn::Identity.new(id_token).user_id)
    elsif error = flash[:google_sign_in][:error]
      logger.error "Google authentication error: #{error}"
      nil
    end
  end
end
