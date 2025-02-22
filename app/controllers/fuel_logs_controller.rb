class FuelLogsController < ApplicationController
  belongs_to :car
  def create
    @car = Car.find(params[:car_id])
    @fuel_log = @car.fuel_logs.build(fuel_log_params)
    if @fuel_log.save
      redirect_to cars_path(selected_car: @car.id), notice: "Fuel log added."
    else
      redirect_to cars_path(selected_car: @car.id), alert: "Failed to add fuel log."
    end
  end

  private

  def fuel_log_params
    params.require(:fuel_log).permit(:fuel_date, :odometer, :fuel_amount)
  end
end
