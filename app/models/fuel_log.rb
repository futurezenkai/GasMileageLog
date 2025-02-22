class FuelLog < ApplicationRecord
  belongs_to :car

  # 燃費計算用のメソッド例（例: 前回の給油との差分から計算するなど、実装は要検討）
  def fuel_efficiency(previous_odometer)
    return nil if fuel_amount.zero? || previous_odometer.nil?
    distance = odometer - previous_odometer
    (distance.to_f / fuel_amount).round(1)
  end
end
