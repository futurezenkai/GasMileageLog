class Car < ApplicationRecord
  belongs_to :user
  has_many :fuel_logs, dependent: :destroy
  accepts_nested_attributes_for :fuel_logs
end
