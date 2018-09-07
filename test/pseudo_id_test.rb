require 'test_helper'

module PolyPseudo
  class PseudoIdTest < Minitest::Test
    def test_identity_from_asn1
      encoded_asn1 = <<-BASE64
        MIIBVAYMYIQQAYdrg+MFAQIBAgEBAgEBFhQwMDAwMDAwNDAwMzIxNDM0NTAwMRYU
        MDAwMDAwMDMyNzMyMjYzMTAwMDACBAEzok4wgfkEUQQdTrTmvUoznOB+4bGfted+
        sc7mnN2M2k9T/c2ZXvOYf8CwniAsnxVgzTzsoEpg8NRJq6aBjFCyBz3NwOulwrNE
        4/Q+2v0eE6R9Cvd8ngeL7QRRBEybIwRxjf6/9xWlMSg3aINSJf2GQaJjkp+uQudg
        slmExVSUUidHeS4rRqh7MEiOulqAYF6UkvXFYCUGU7DRScIxGf8xPYmULaYnMSle
        cpeMBFEElI6gAq+crdUFVzkF7bNFX+tEUIiGvc7daUbYpoatwogyGveoPvgOt3MC
        t38iHgW3leqaRomZgNHbjQEgCCy/2VJgdwQYDSs/j++K1KtUMOgEEAAAAAAAAAAA
        AAAAAAAAAAA=
      BASE64

      identity_or_pseudonym = PseudoId.from_asn1(encoded_asn1)
      assert identity_or_pseudonym.is_a?(PseudoId)
      assert identity_or_pseudonym.is_a?(Identity)
      assert !identity_or_pseudonym.is_a?(Pseudonym)

      assert_equal "2.16.528.1.1003.61829.1.2.1", identity_or_pseudonym.type
      assert_equal 1, identity_or_pseudonym.schema_version
      assert_equal 1, identity_or_pseudonym.schema_key_version
      assert_equal "00000003273226310000", identity_or_pseudonym.recipient
      assert_equal 20161102, identity_or_pseudonym.recipient_key_set_version
      assert_equal "041D4EB4E6BD4A339CE07EE1B19FB5E77EB1CEE69CDD8CDA4F53FDCD995EF3987FC0B09E202C9F1560CD3CECA04A60F0D449ABA6818C50B2073DCDC0EBA5C2B344E3F43EDAFD1E13A47D0AF77C9E078BED",
                   identity_or_pseudonym.point_1.to_bn.to_s(16)
      assert_equal "044C9B2304718DFEBFF715A531283768835225FD8641A263929FAE42E760B25984C55494522747792E2B46A87B30488EBA5A80605E9492F5C560250653B0D149C23119FF313D89942DA62731295E72978C",
                   identity_or_pseudonym.point_2.to_bn.to_s(16)
      assert_equal "04948EA002AF9CADD505573905EDB3455FEB44508886BDCEDD6946D8A686ADC288321AF7A83EF80EB77302B77F221E05B795EA9A46899980D1DB8D0120082CBFD952607704180D2B3F8FEF8AD4AB5430E8",
                   identity_or_pseudonym.point_3.to_bn.to_s(16)
    end

    def test_pseudonym_from_asn1
      encoded_asn1 = <<-BASE64
        MIIBQAYKYIQQAYdrCgECAgIBAQIBARYUMDAwMDAwMDQ4MjI0NzczNDgwMDEW
        FDAwMDAwMDAzMjczMjI2MzEwMDAwAgEBAgFFMIH5BFEENaMSbna99YTBtCF7
        s0VgCyBQO0g5JNp37ATOaP9afooDmjpaJTbUO1EhJodSQs52L8t9LRX3fu6p
        VUi/D6dcqy9g5ULi8/KdHCv+4T3uBjQEUQSnBisuRUE7RecSWg3tINoRs8ey
        5ZRQyBIKUisdQBIgiVUzkyuFGMWUf7BxmnziTZS9fJmQ8I9EkfA/YfvTom4n
        /z/V0nSWNB6sp+IhgKB0ZwRRBMWP7XP8/32LUGg9QRnTKfjlY1isI5xNgUMz
        r36jdlZ12SzdtHRSBR+LDBR8WeouGfq5rhqSRAnK663A3qBF4vdaMQVh/Nf6
        SI642O7xkBpK
      BASE64

      identity_or_pseudonym = PseudoId.from_asn1(encoded_asn1)
      assert identity_or_pseudonym.is_a?(PseudoId)
      assert identity_or_pseudonym.is_a?(Pseudonym)
      assert !identity_or_pseudonym.is_a?(Identity)

      assert_equal "2.16.528.1.1003.10.1.2.2", identity_or_pseudonym.type
      assert_equal 1, identity_or_pseudonym.schema_version
      assert_equal 1, identity_or_pseudonym.schema_key_version
      assert_equal "00000003273226310000", identity_or_pseudonym.recipient
      assert_equal 1, identity_or_pseudonym.recipient_key_set_version
      assert_equal "0435A3126E76BDF584C1B4217BB345600B20503B483924DA77EC04CE68FF5A7E8A039A3A5A2536D43B512126875242CE762FCB7D2D15F77EEEA95548BF0FA75CAB2F60E542E2F3F29D1C2BFEE13DEE0634",
                   identity_or_pseudonym.point_1.to_bn.to_s(16)
      assert_equal "04A7062B2E45413B45E7125A0DED20DA11B3C7B2E59450C8120A522B1D401220895533932B8518C5947FB0719A7CE24D94BD7C9990F08F4491F03F61FBD3A26E27FF3FD5D27496341EACA7E22180A07467",
                   identity_or_pseudonym.point_2.to_bn.to_s(16)
      assert_equal "04C58FED73FCFF7D8B50683D4119D329F8E56358AC239C4D814333AF7EA3765675D92CDDB47452051F8B0C147C59EA2E19FAB9AE1A924409CAEBADC0DEA045E2F75A310561FCD7FA488EB8D8EEF1901A4A",
                   identity_or_pseudonym.point_3.to_bn.to_s(16)
    end
  end
end
