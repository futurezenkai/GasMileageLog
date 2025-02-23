require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "fuel_log_notification" do
    mail = UserMailer.fuel_log_notification
    assert_equal "Fuel log notification", mail.subject
    assert_equal [ "to@example.org" ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match "Hi", mail.body.encoded
  end
end
