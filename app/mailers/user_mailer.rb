class UserMailer < ApplicationMailer
  def fuel_log_notification(user, fuel_log)
    @user = user
    @fuel_log = fuel_log
    # ここで、燃費計算を行うため、FuelLogモデルの fuel_efficiency(previous_odometer) を利用
    # 例えば、前回のオドメーターの値を fuel_log.previous_odometer と仮定
    @fuel_efficiency = fuel_log.fuel_efficiency(fuel_log.previous_record&.odometer)

    mail to: @user.email, subject: "今回の燃費情報（#{@fuel_log.car.name}）"
  end
end

