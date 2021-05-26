class Lending < ApplicationRecord
  validates :borrower_id, :lender_name, :content, presence: true

  scope :not_returned, -> { where(has_returned: false) }
end
