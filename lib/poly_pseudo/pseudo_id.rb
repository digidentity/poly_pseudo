module PolyPseudo
  module PseudoId
    def self.from_asn1(encoded)
      asn1 = OpenSSL::ASN1.decode(Base64.decode64(encoded))

      case asn1.value[0].value.to_s
      when /\A.*1\.2\.1\Z/
        Identity.from_asn1(asn1)
      when /\A.*1\.2\.2\Z/
        Pseudonym.from_asn1(asn1)
      when /\A.*1\.2\.3\Z/
        Identity.from_asn1(asn1.value[1].value[0])
      when /\A.*1\.2\.4\Z/
        Pseudonym.from_asn1(asn1.value[1].value[0])
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
