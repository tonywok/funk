require 'test_helper'

class FunkTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Funk::VERSION
  end
end
