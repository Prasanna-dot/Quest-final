class ForgotMailer < ApplicationMailer
  $pin
  def forgot_password
    $pin = rand.to_s[2..7]
    @user = params[:user]

    mail to: @user.email
  end
end
