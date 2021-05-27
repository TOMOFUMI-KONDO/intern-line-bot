require 'test_helper'

class ThankingTest < ActiveSupport::TestCase
  test 'valid Thanking model' do
    thanking = Thanking.new(name: 'ice', url: 'https://example.com', lending_id: lendings(:one).id)
    assert thanking.valid?
  end

  test 'name must be presence' do
    thanking = Thanking.new(url: 'https://example.com', lending_id: lendings(:one).id)
    assert_not thanking.valid?
  end

  test 'url must be presence' do
    thanking = Thanking.new(name: 'ice', lending_id: lendings(:one).id)
    assert_not thanking.valid?
  end

  test 'lending_id must be presence' do
    thanking = Thanking.new(name: 'ice', url: 'https://example.com')
    assert_not thanking.valid?
  end
end
