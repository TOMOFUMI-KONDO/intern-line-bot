require 'test_helper'

class LendingThankingTest < ActiveSupport::TestCase
  test 'valid LendingThanking model' do
    lending_thanking = LendingThanking.new(lending: lendings(:one), thanking: thankings(:one))
    assert lending_thanking.valid?
  end

  test 'lending_id must be presence' do
    lending_thanking = LendingThanking.new(thanking: thankings(:one))
    assert_not lending_thanking.valid?
  end

  test 'thanking_id must be presence' do
    lending_thanking = LendingThanking.new(lending: lendings(:one))
    assert_not lending_thanking.valid?
  end

  test 'lending_id must be associated exist lending' do
    not_exist_lending_id = lendings.map(&:id).max + 1
    thanking = LendingThanking.new(lending_id: not_exist_lending_id, thanking_id: thankings(:one).id)
    assert_not thanking.valid?
  end

  test 'thanking_id must be associated exist thanking' do
    not_exist_thanking_id = thankings.map(&:id).max + 1
    lending_thanking = LendingThanking.new(lending_id: lendings(:one).id, thanking_id: not_exist_thanking_id)
    assert_not lending_thanking.valid?
  end
end
