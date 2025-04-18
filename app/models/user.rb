class User < ApplicationRecord
  validates :name, :phone, :role, :district, :taluka, presence: true

  validates :phone, uniqueness: true, format: { with: /\A[6-9]\d{9}\z/, message: "must be a valid 10-digit Indian phone number" }

  has_many :proposals

  has_many :negotiations
end
