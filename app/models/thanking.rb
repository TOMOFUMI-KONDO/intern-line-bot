class Thanking < ApplicationRecord
  has_many :lending_thankings
  has_many :lendings, through: :lending_thankings

  validates :name, :url, presence: true

  def self.random_choice
    Thanking.find(Thanking.pluck(:id).sample)
  end
end
