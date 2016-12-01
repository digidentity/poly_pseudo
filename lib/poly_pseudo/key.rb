module PolyPseudo
  class Key
    attr_reader :scheme_version, :scheme_key_version, :type, :recipient, :recipient_key_set_version, :ec

    def initialize(attributes)
      @scheme_version            = attributes["SchemeVersion"]
      @scheme_key_version        = attributes["SchemeKeyVersion"]
      @type                      = attributes["Type"]
      @recipient                 = attributes["Recipient"]
      @recipient_key_set_version = attributes["RecipientKeySetVersion"]
      @ec                        = attributes["PrivateKey"]
    end
  end
end
