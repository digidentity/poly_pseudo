module PolyPseudo
  class Identity
    include PolyPseudo::PseudoId

    def self.from_asn1(asn1)
      attributes = {}
      attributes["Type"]                   = asn1.value[0].value.to_s
      attributes["SchemaVersion"]          = asn1.value[1].value.to_i
      attributes["SchemaKeyVersion"]       = asn1.value[2].value.to_i
      attributes["Creator"]                = asn1.value[3].value.to_s
      attributes["Recipient"]              = asn1.value[4].value.to_s
      attributes["RecipientKeySetVersion"] = asn1.value[5].value.to_i
      attributes["Point1"]                 = OpenSSL::PKey::EC::Point.new(PolyPseudo.config.group, OpenSSL::BN.new(asn1.value[6].value[0].value, 2))
      attributes["Point2"]                 = OpenSSL::PKey::EC::Point.new(PolyPseudo.config.group, OpenSSL::BN.new(asn1.value[6].value[1].value, 2))
      attributes["Point3"]                 = OpenSSL::PKey::EC::Point.new(PolyPseudo.config.group, OpenSSL::BN.new(asn1.value[6].value[2].value, 2))

      new(attributes)
    end

    # @param [PolyPseudo::Key] key
    def decrypt(key)
      PolyPseudo.init!

      public_key = key.ec.public_key

      raise "Invalid key for decryption" if point_3 != public_key

      private_key = key.ec.private_key

      identity_point = point_1
          .mul(private_key)
          .invert!
          .add(point_2)
          .make_affine!

      decoded = Util.oaep_decode(identity_point.x.to_s(2).rjust(40, "\x00"))
      @identity = decoded.slice(3, decoded[2].ord).force_encoding("UTF-8")
    end

    def identity
      @identity || raise('Identity not decrypted yet. call .decrypt first')
    end

    alias_method :pseudo_id, :identity
  end
end
