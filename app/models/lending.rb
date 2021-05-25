class Lending < ApplicationRecord
  validates :borrower_id, presence: true
  validates :lender_name, presence: true
  validates :content, presence: true
end
