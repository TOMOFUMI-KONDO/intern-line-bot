require 'test_helper'

class LendingThankingTest < ActiveSupport::TestCase
  test 'valid LendingThanking model' do
    lending_thanking = LendingThanking.new(lending_id: lendings(:one).id, thanking_id: thankings(:one).id)
    assert lending_thanking.valid?
  end
end
