class LendingThanking < ApplicationRecord
  belongs_to :lending
  belongs_to :thanking

  validates :lending_id, :thanking_id, presence: true
end
