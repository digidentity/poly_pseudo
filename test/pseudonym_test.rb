require 'test_helper'

module PolyPseudo
  class PseudonymTest < Minitest::Test
    def test_decrypt
      hex1 = "0467C75B18B7DACA152A0E91266BEC771108E101A9BF3B8A70635118B7126449BA9C0A9927E29B6CBD32CEDD1D48495B0775C4C81D247A3273B6E311E2ADEE011B3DB7D4A1C44F64FFA021E74785426ACC"
      hex2 = "0420A474A1EA1001C3F8C20CB2C66DD696C72C4E922D01EBDB9DEBC96232AA25377E6854EA76E483A6CC5807FE9EB59A69A59416F6432286E4AF7BCAE9FB31586E920EB40208ACC6877B1095731EE8D059"
      hex3 = "043407A1D74323EE113E06BA434AD5C16AB77766E92AB0EFDFEB8A350C1ED202B99396A5511A39627066DE36D46DB20F30D6B0A91087FE30888A09A237C85373C589A211CA653567D9131852388A9780DF"

      p1 = OpenSSL::PKey::EC::Point.new(PolyPseudo.config.group, OpenSSL::BN.new(hex1, 16))
      p2 = OpenSSL::PKey::EC::Point.new(PolyPseudo.config.group, OpenSSL::BN.new(hex2, 16))
      p3 = OpenSSL::PKey::EC::Point.new(PolyPseudo.config.group, OpenSSL::BN.new(hex3, 16))

      pseudonym = Pseudonym.new(
          "Type"                   => "2.16.528.1.TODO.1.2.2",
          "SchemaVersion"          => 1,
          "SchemaKeyVersion"       => 1,
          "Recipient"              => "00000001855432950000",
          "RecipientKeySetVersion" => "02092016",
          "Point1"                 => p1,
          "Point2"                 => p2,
          "Point3"                 => p3,
      )
      decryption_key = Util.read_key(File.read('test/fixtures/EP_Decryption.pem'))
      closing_key = Util.read_key(File.read('test/fixtures/EP_Closing.pem'))
      pseudonym.decrypt(decryption_key, closing_key)

      assert_equal "01012014039625D22DE2F8CD9B22274BB01BDFFE652091FB649DFB19F3C3B59D3195D40CDA4023374A62B46E6D", pseudonym.pseudo_id
    end
  end
end
