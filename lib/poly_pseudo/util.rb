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

    def self.i2osp(x, len = nil)
      raise ArgumentError, "integer too large" if len && x >= 256**len

      StringIO.open do |buffer|
        while x > 0
          b = (x & 0xFF).chr
          x >>= 8
          buffer << b
        end
        s = buffer.string
        s.force_encoding(Encoding::BINARY) if s.respond_to?(:force_encoding)
        s.reverse!
        s = len ? s.rjust(len, "\0") : s
      end
    end

    def self.mgf1(z, l)
      t = ''

      (0..(l / 10)).each { |i|
        t += Digest::SHA384.digest(z + i2osp(i, 4))
      }

      t[0...l]
    end

    def self.xor s1, s2
      b1 = s1.unpack('c*')
      b2 = s2.unpack('c*')

      if b1.length != b2.length
        raise DecodeError, 'cannot xor strings of different lengths!'
      end

      b1.zip(b2).map { |a, b| a ^ b }.pack('c*')
    end
  end
end
