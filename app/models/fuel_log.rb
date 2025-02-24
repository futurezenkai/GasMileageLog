class FuelLog < ApplicationRecord
  belongs_to :car

  validates :fuel_date, :fuel_amount, :odometer, presence: true
  validate  :fuel_date_after_minimum
  validates :fuel_amount, numericality: { greater_than_or_equal_to: 0 }
  validates :odometer, numericality: { greater_than_or_equal_to: 0 }
  validate  :odometer_must_be_within_previous_and_next_records

  def fuel_date_after_minimum
    minimum_date = Date.new(2000, 1, 1)
    if fuel_date.present? && fuel_date < minimum_date
      errors.add(:fuel_date, "は2000年1月1日以降でなければなりません")
    end
  end

  # 前回の給油日のオドメーター値を取得するメソッド
  def previous_record
    car.fuel_logs.where("fuel_date < ?", fuel_date).order(fuel_date: :desc).first
  end

  def next_record
    car.fuel_logs.where("fuel_date > ?", fuel_date).order(fuel_date: :asc).first
  end

  # オドメーターが前回・次回の給油記録の間にあることを検証する
  def odometer_must_be_within_previous_and_next_records
    if (prev = previous_record)
      if odometer < prev.odometer
        errors.add(:odometer, "は前回（#{prev.fuel_date.strftime('%Y/%m/%d')}の）の値（#{prev.odometer} Km）以上でなければなりません")
      end
    end

    if (nxt = next_record)
      if odometer > nxt.odometer
        errors.add(:odometer, "は次回（#{nxt.fuel_date.strftime('%Y/%m/%d')}の）の値（#{nxt.odometer} Km）以下でなければなりません")
      end
    end
  end

  # 燃費計算メソッド（距離÷給油量）
  def fuel_efficiency(previous_odometer_value)
    return nil if fuel_amount.zero? || previous_odometer_value.nil?
    distance = odometer - previous_odometer_value
    (distance.to_f / fuel_amount).round(1)
  end
end
