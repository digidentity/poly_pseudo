module PolyPseudo
  class Pseudonym
    include PolyPseudo::PseudoId

    def self.from_asn1(asn1)
      attributes = {}
      attributes["Type"]                   = asn1.value[0].value.to_s
      attributes["SchemaVersion"]          = asn1.value[1].value.to_i
      attributes["SchemaKeyVersion"]       = asn1.value[2].value.to_i
      attributes["Creator"]                = asn1.value[3].value.to_s
      attributes["Recipient"]              = asn1.value[4].value.to_s
      attributes["RecipientKeySetVersion"] = asn1.value[5].value.to_i
      attributes["Point1"]                 = OpenSSL::PKey::EC::Point.new(PolyPseudo.config.group, OpenSSL::BN.new(asn1.value[7].value[0].value, 2))
      attributes["Point2"]                 = OpenSSL::PKey::EC::Point.new(PolyPseudo.config.group, OpenSSL::BN.new(asn1.value[7].value[1].value, 2))
      attributes["Point3"]                 = OpenSSL::PKey::EC::Point.new(PolyPseudo.config.group, OpenSSL::BN.new(asn1.value[7].value[2].value, 2))

      new(attributes)
    end

    # @param [PolyPseudo::Key] closing_key
    def decrypt(decryption_key, closing_key)
      PolyPseudo.init!
      decryption_private_key = decryption_key.ec.private_key
      closing_private_key    = closing_key.ec.private_key

      product            = decryption_private_key.mod_mul(closing_private_key, PolyPseudo.config.group.order)
      point_2_multiplied = point_2.mul(closing_private_key)

      pseudo_point        = point_1
          .mul(product)
          .invert!
          .add(point_2_multiplied)
          .make_affine!

      @pseudonym = closing_key.recipient_key_set_version.to_s + pseudo_point.to_hex
    end

    def pseudonym
      @pseudonym || raise("Pseudonym not decrypted yet. call .decrypt first")
    end

    alias_method :pseudo_id, :pseudonym
  end
end
