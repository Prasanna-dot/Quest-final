# Preview all emails at http://localhost:3000/rails/mailers/forgot_mailer
class ForgotMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/forgot_mailer/forgot_password
  def forgot_password
    ForgotMailer.forgot_password
  end

end
