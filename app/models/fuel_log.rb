class FuelLog < ApplicationRecord
  belongs_to :car

  # 日付は 2000-01-01 以降であること
  validate :fuel_date_after_minimum
  # fuel_amount は 0 以上であること
  validates :fuel_amount, numericality: { greater_than_or_equal_to: 0 }
  # odometer は 0 以上であること
  validates :odometer, numericality: { greater_than_or_equal_to: 0 }


  def fuel_date_after_minimum
    minimum_date = Date.new(2000, 1, 1)
    if fuel_date.present? && fuel_date < minimum_date
      errors.add(:fuel_date, "は2000年1月1日以降でなければなりません")
    end
  end

  # 燃費計算用のメソッド例（例: 前回の給油との差分から計算するなど、実装は要検討）
  def fuel_efficiency(previous_odometer)
    return nil if fuel_amount.zero? || previous_odometer.nil?
    distance = odometer - previous_odometer
    (distance.to_f / fuel_amount).round(1)
  end
end
