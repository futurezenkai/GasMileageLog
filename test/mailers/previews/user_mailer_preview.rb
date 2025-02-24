# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/fuel_log_notification
  def fuel_log_notification
    UserMailer.fuel_log_notification
  end
end
