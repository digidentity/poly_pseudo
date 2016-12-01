require 'test_helper'

class PolyPseudoTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::PolyPseudo::VERSION
  end

  def test_configure
    PolyPseudo.configure do |config|
      assert_kind_of PolyPseudo::Config, config
    end
  end
end
