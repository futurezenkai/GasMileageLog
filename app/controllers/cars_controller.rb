class CarsController < ApplicationController
  def index
    @cars = Car.all
  end

  def show
    @car = Car.find(params[:id])
  end

  def new
    @car = Car.new
  end

  def create
    @car = Car.new(car_params)
    @car.user = current_user # ユーザー認証の仕組みに合わせて設定

    if @car.save
      redirect_to @car, notice: '車が正常に作成されました。'
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
      redirect_to @car, notice: '車の情報が更新されました。'
    else
      render :edit
    end
  end

  def destroy
    @car = Car.find(params[:id])
    @car.destroy
    redirect_to cars_path, notice: '車が削除されました。'
  end

  private

  def car_params
    params.require(:car).permit(:name, :model)
  end
end
