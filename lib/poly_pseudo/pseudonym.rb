module PolyPseudo
  class Pseudonym
    include PolyPseudo::PseudoId

    # @param [PolyPseudo::Key] closing_key
    def decrypt(decryption_key, closing_key)
      PolyPseudo.init!
      decryption_private_key = decryption_key.ec.private_key
      closing_private_key    = closing_key.ec.private_key

      product            = decryption_private_key.mod_mul(closing_private_key, PolyPseudo.config.group.order)
      point_2_multiplied = point_2.mul(closing_private_key)

      pseudo_point        = point_1.mul(product)
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
