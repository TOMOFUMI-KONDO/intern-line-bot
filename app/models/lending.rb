class Lending < ApplicationRecord
  has_many :lending_thankings
  has_many :thankings, through: :lending_thankings

  validates :borrower_id, :lender_name, :content, presence: true

  scope :not_returned, -> { where(has_returned: false) }

  scope :count_per_lender_content, -> {
    group(:lender_name, :content).select("lender_name, content, count(*)")
  }

  scope :count_per_content, -> {
    group(:content).select('content, count(*)')
  }

  def return_content!
    update!(has_returned: true)
  end

  def self.format_per_lender_content_count(per_lender_content_counts)
    per_lender_content_counts.each_with_object({}) do |lending, hash|
      lender = lending.lender_name
      content = lending.content
      count = lending.count

      if hash.key?(lender)
        hash[lender][content] = count
      else
        hash[lender] = { content => count }
      end
    end
  end
end
