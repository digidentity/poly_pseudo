require 'test_helper'

module PolyPseudo
  class UtilTest < Minitest::Test
    def test_read_key
      key = Util.read_key(File.read('test/fixtures/EI_Decryption.pem'))

      assert_equal "1", key.scheme_version
      assert_equal "1", key.scheme_key_version
      assert_equal "EI Decryption" , key.type
      assert_equal "00000001855432950000", key.recipient
      assert_equal "02092016", key.recipient_key_set_version
      assert key.ec.is_a?(OpenSSL::PKey::EC)
    end
  end
end
