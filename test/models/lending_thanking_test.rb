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

  test 'lending_id must be associated exist lending' do
    lending_ids = lendings.map(&:id)
    not_exist_lending_id = generate_not_repeatable_id(lending_ids)

    thanking = LendingThanking.new(lending_id: not_exist_lending_id, thanking_id: thankings(:one).id)
    assert_not thanking.valid?
  end

  test 'thanking_id must be associated exist thanking' do
    thanking_ids = thankings.map(&:id)
    not_exist_thanking_id = generate_not_repeatable_id(thanking_ids)

    lending_thanking = LendingThanking.new(lending_id: lendings(:one).id, thanking_id: not_exist_thanking_id)
    assert_not lending_thanking.valid?
  end

  private

  # fixtureのデータと被らないidを生成するためのメソッド
  def generate_not_repeatable_id(exist_ids)
    not_repeatable_id = nil
    loop do
      not_repeatable_id = rand(1..exist_ids.length)
      break unless exist_ids.include?(not_repeatable_id)
    end
    not_repeatable_id
  end
end
