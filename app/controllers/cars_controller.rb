class CarsController < ApplicationController
  def index
    @cars = current_user.cars  # ログインユーザーの車を取得する例

    # パラメータで選択された車IDがある場合はそれを使い、なければ最初の車を選択する
    @selected_car =
      if params[:selected_car].present?
        @cars.find_by(id: params[:selected_car])
      else
        @cars.first
      end

    # 選択中の車があればその fuel_logs を取得、なければ空の配列を設定
    @fuel_logs = @selected_car ? @selected_car.fuel_logs.order(fuel_date: :asc) : []
  end

  def show
    @car = Car.find(params[:id])
  end

  def new
    @car = Car.new
    @car.fuel_logs.build
  end

  def create
    @car = Car.new(car_params)
    @car.user = current_user # ユーザー認証の仕組みに合わせて設定

    if @car.save
      redirect_to cars_path(selected_car: @car.id), notice: "Car was successfully created."
    else
      render :new
    end
  end

  def edit
    @car = Car.find(params[:id])
  end

  def update
    @car = Car.find(params[:id])
    if @car.update(car_params)
      redirect_to @car, notice: "車の情報が更新されました。"
    else
      render :edit
    end
  end

  def destroy
    @car = Car.find(params[:id])
    @car.destroy
    redirect_to cars_path, notice: "車が削除されました。"
  end

  private

  def car_params
    params.require(:car).permit(:name, :model, fuel_logs_attributes: [ :fuel_date, :odometer, :fuel_amount ])
  end
end
