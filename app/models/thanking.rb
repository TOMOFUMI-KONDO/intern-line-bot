class Thanking < ApplicationRecord
  has_many :lending_thankings
  has_many :lendings, through: :lending_thankings

  validates :name, :url, presence: true

  scope :random_choice, -> {
    find(Thanking.pluck(:id).sample)
  }
end
