module PolyPseudo
  module Util
    extend self

    # @param [String] raw in pem format with metadata
    def read_key(raw)
      attributes               = {}
      lines                    = raw.lines
      meta_lines               = lines.slice!(1, 6)
      attributes["PrivateKey"] = OpenSSL::PKey::EC.new(lines.join)

      meta_lines.each do |line|
        key, value      = line.split(":").map(&:strip)
        attributes[key] = value
      end

      Key.new(attributes)
    end

    # @param [OpenSSL::BN] bn
    def oaep_decode(em, p = '', hlen = 10)
      raise 'message is too short!' if em.length < hlen * 2 + 1

      maskedSeed = em[0...hlen]
      maskedDB   = em[hlen..-1]

      seedMask = mgf1 maskedDB, hlen
      seed     = xor maskedSeed, seedMask
      dbMask   = mgf1 seed, em.size - hlen
      db       = xor maskedDB, dbMask
      pHash    = Digest::SHA384.digest(p)[0...hlen]

      ind = db.index("\x01", hlen)
      raise 'message is invalid!' if ind.nil?

      pHash2 = db[0...hlen]
      ps     = db[hlen...ind]
      m      = db[(ind + 1)..-1]

      raise 'message is invalid!' unless ps.bytes.all?(&:zero?)
      raise "specified p = #{p.inspect} is wrong!" unless pHash2 == pHash

      m
    end

    def self.mgf1(z, l)
      t = ''

      n = (l - 1) / 48 + 1
      n.times do |i|
        t << Digest::SHA384.digest(z + [i].pack('N'))
      end

      t[0...l]
    end

    def self.xor s1, s2
      b1 = s1.unpack('c*')
      b2 = s2.unpack('c*')

      if b1.length != b2.length
        raise 'cannot xor strings of different lengths!'
      end

      b1.zip(b2).map { |a, b| a ^ b }.pack('c*')
    end
  end
end
