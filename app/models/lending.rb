class Lending < ApplicationRecord
  validates :borrower_id, :lender_name, :content, presence: true

  scope :per_lender, -> {
    group(:lender_name, :content).select("lender_name, content, count(*)").each_with_object({}) do |lending, hash|
      lender = lending.lender_name.intern
      content = lending.content.intern
      count = lending.count

      if hash.key?(lender)
        hash[lender][content] = count
      else
        hash[lender] = { content => count }
      end
    end
  }
end
