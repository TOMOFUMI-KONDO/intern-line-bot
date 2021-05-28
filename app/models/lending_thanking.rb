class LendingThanking < ApplicationRecord
  validates :lending_id, :thanking_id, presence: true

  belongs_to :lending
  belongs_to :thanking
end
