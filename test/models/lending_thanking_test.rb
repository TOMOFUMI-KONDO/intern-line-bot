require 'test_helper'

class LendingThankingTest < ActiveSupport::TestCase
  test 'valid LendingThanking model' do
    lending_thanking = LendingThanking.new(lending_id: lendings(:one).id, thanking_id: thankings(:one).id)
    assert lending_thanking.valid?
  end

  test 'lending_id must be presence' do
    lending_thanking = LendingThanking.new(thanking_id: thankings(:one).id)
    assert_not lending_thanking.valid?
  end

  test 'thanking_id must be presence' do
    lending_thanking = LendingThanking.new(lending_id: lendings(:one).id)
    assert_not lending_thanking.valid?
  end
end
