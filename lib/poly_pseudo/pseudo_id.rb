module PolyPseudo
  module PseudoId
    def self.from_asn1(encoded)
      attributes                           = {}
      asn1                                 = OpenSSL::ASN1.decode(Base64.decode64(encoded))
      attributes["Type"]                   = asn1.value[0].value.to_s
      attributes["SchemaVersion"]          = asn1.value[1].value.to_i
      attributes["SchemaKeyVersion"]       = asn1.value[2].value.to_i
      attributes["Creator"]                = asn1.value[3].value.to_s
      attributes["Recipient"]              = asn1.value[4].value.to_s
      attributes["RecipientKeySetVersion"] = asn1.value[5].value.to_i
      attributes["Point1"]                 = OpenSSL::PKey::EC::Point.new(PolyPseudo.config.group,
                                                                          OpenSSL::BN.new(asn1.value[6].value[0].value, 2))
      attributes["Point2"]                 = OpenSSL::PKey::EC::Point.new(PolyPseudo.config.group,
                                                                          OpenSSL::BN.new(asn1.value[6].value[1].value, 2))
      attributes["Point3"]                 = OpenSSL::PKey::EC::Point.new(PolyPseudo.config.group,
                                                                          OpenSSL::BN.new(asn1.value[6].value[2].value, 2))

      case attributes["Type"]
      when /\A.*1\.2\.1\Z/
        Identity.new(attributes)
      when /\A.*1\.2\.2\Z/
        Pseudonym.new(attributes)
      else
        raise "Invalid type"
      end
    end

    attr_reader :type, :schema_version, :schema_key_version, :creator, :recipient, :recipient_key_set_version, :point_1, :point_2, :point_3

    def initialize(attributes)
      @type                      = attributes["Type"]
      @schema_version            = attributes["SchemaVersion"]
      @schema_key_version        = attributes["SchemaKeyVersion"]
      @recipient                 = attributes["Creator"]
      @recipient                 = attributes["Recipient"]
      @recipient_key_set_version = attributes["RecipientKeySetVersion"]
      @point_1                   = attributes["Point1"]
      @point_2                   = attributes["Point2"]
      @point_3                   = attributes["Point3"]
    end
  end
end
