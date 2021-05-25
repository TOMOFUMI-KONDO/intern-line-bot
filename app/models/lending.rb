class Lending < ApplicationRecord
  validates :borrower_id, :lender_name, :content, presence: true
end
