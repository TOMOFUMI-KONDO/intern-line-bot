class Thanking < ApplicationRecord
  validates :name, :url, presence: true

  has_many :lending_thankings
  has_many :lendings, through: :lending_thankings
end
