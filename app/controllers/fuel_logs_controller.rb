class FuelLogsController < ApplicationController
  def create
    @car = Car.find(params[:car_id])
    @fuel_log = @car.fuel_logs.build(fuel_log_params)
    if @fuel_log.save
      UserMailer.fuel_log_notification(current_user, @fuel_log).deliver_later
      redirect_to cars_path(selected_car: @car.id), notice: "Fuel log added."
    else
      redirect_to cars_path(selected_car: @car.id), alert: "Failed to add fuel log."
    end
  end

  def destroy
    @fuel_log = FuelLog.find(params[:id])
    if @fuel_log.created_at > 1.hour.ago
      @fuel_log.destroy
      flash[:notice] = "レコードを削除しました"
    else
      flash[:alert] = "削除できる時間が経過しています"
    end
    redirect_to cars_path(selected_car: params[:car_id])
  end

  private

  def fuel_log_params
    params.require(:fuel_log).permit(:fuel_date, :odometer, :fuel_amount)
  end
end
