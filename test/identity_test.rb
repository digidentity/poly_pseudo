require 'test_helper'

module PolyPseudo
  class IdentityTest < Minitest::Test
    def test_decrypt
      hex1 = "04186E9AF2AAD1960D911F6D30F002CDCE0A291968F42EE21BCDC2D8317A77C015B6BE5441DDC3F7D161359CFAC42B7969F4D38175C522FEED4F26FE067AF21673F6BD8B1937351FA1B4694F6F4513469C"
      hex2 = "04D3186F6FAB6071FB160EAB37903A5F5E46B4ADF9BC2738C7DFB69D7789B47073319555794635CEA17E4B6D51BC317929B426440FB5AB02645569444728DDF1BAAF30EF78C6EB5EE876EE8496918C6B07"
      hex3 = "04A447C2973BC3708A67478CCCCC0476F069E88F8004F127A57DCC0C8BB0B769E156CE2454E947F2096AE4D6CC2CD02E3D86D180BEE904C8CE48AF427DD64824A5685093F24C24AD1E0C9C7AC68B5FCFAF"

      p1 = OpenSSL::PKey::EC::Point.new(PolyPseudo.config.group, OpenSSL::BN.new(hex1, 16))
      p2 = OpenSSL::PKey::EC::Point.new(PolyPseudo.config.group, OpenSSL::BN.new(hex2, 16))
      p3 = OpenSSL::PKey::EC::Point.new(PolyPseudo.config.group, OpenSSL::BN.new(hex3, 16))

      identity = Identity.new(
          "Type"                   => "2.16.528.1.TODO.1.2.1",
          "SchemaVersion"          => 1,
          "SchemaKeyVersion"       => 1,
          "Recipient"              => "00000001855432950000",
          "RecipientKeySetVersion" => "02092016",
          "Point1"                 => p1,
          "Point2"                 => p2,
          "Point3"                 => p3,
      )
      identity_key = Util.read_key(File.read('test/fixtures/EI_Decryption.pem'))
      identity.decrypt(identity_key)

      assert_equal "1234567890", identity.pseudo_id
    end
  end
end
