require 'test_helper'

class ThankingTest < ActiveSupport::TestCase
  test 'valid Thanking model' do
    thanking = Thanking.new(name: 'ice', url: 'https://example.com', lending_id: lendings(:one).id)
    assert thanking.valid?
  end
end
