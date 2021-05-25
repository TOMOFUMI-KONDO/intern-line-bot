require 'test_helper'

class LendingTest < ActiveSupport::TestCase
  test 'valid Lending model' do
    lending = Lending.new(borrower_id: 'abcedfg', lender_name: 'Bob', content: 'book')
    assert lending.valid?
  end

  test 'borrower_id_must_be_presence' do
    lending = Lending.new(lender_name: 'Bob', content: 'book')
    assert_not lending.valid?
  end

  test 'lender_name_must_be_presence' do
    lending = Lending.new(borrower_id: 'abcedfg', content: 'book')
    assert_not lending.valid?
  end

  test 'content_id_must_be_presence' do
    lending = Lending.new(borrower_id: 'Bob', lender_name: 'book')
    assert_not lending.valid?
  end
end
