class Thanking < ApplicationRecord
  belongs_to :lending

  validates :name, :url, :lending_id, presence: true
end
