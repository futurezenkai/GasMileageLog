require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "fuel log notification" do
    user = User.new(email: "test@example.com")
    car = Car.new(name: "Test Car")
    # fuel_log に必要な属性と関連付けを作成する
    fuel_log = FuelLog.new(
      fuel_date: Date.today,
      odometer: 1000,
      fuel_amount: 10,
      car: car
    )

    mail = UserMailer.fuel_log_notification(user, fuel_log)

    assert_equal "今回の燃費情報（#{fuel_log.car.name}）", mail.subject
    assert_equal [ user.email ], mail.to
  end
end
