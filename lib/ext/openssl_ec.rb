module PolyPseudo
  module OpenSSLPointExtension
    extend FFI::Library
    ffi_lib PolyPseudo.config.ffi_lib

    NID_brainpoolP320r1 = 929

    POINT_CONVERSION_COMPRESSED   = 2
    POINT_CONVERSION_UNCOMPRESSED = 4

    attach_function :EC_GROUP_new_by_curve_name, [:int], :pointer
    attach_function :EC_POINT_free, [:pointer], :int
    attach_function :EC_POINT_add, [:pointer, :pointer, :pointer, :pointer, :pointer], :int
    attach_function :EC_POINT_point2hex, [:pointer, :pointer, :int, :pointer], :string
    attach_function :EC_POINT_hex2point, [:pointer, :string, :pointer, :pointer], :pointer
    attach_function :EC_POINT_new, [:pointer], :pointer
    attach_function :BN_new, [], :pointer
    attach_function :BN_free, [:pointer], :int
    attach_function :BN_bn2hex, [:pointer], :string
    attach_function :EC_POINT_get_affine_coordinates_GFp, [:pointer, :pointer, :pointer, :pointer, :pointer], :int

    def self.add(point_0, point_1)
      group       = EC_GROUP_new_by_curve_name(NID_brainpoolP320r1)
      point_0_hex = point_0.to_bn.to_s(16)
      point_0_pt  = EC_POINT_hex2point(group, point_0_hex, nil, nil)
      point_1_hex = point_1.to_bn.to_s(16)
      point_1_pt  = EC_POINT_hex2point(group, point_1_hex, nil, nil)
      sum_point   = EC_POINT_new(group)
      success     = EC_POINT_add(group, sum_point, point_0_pt, point_1_pt, nil)
      if success
        hex = EC_POINT_point2hex(group, sum_point, POINT_CONVERSION_COMPRESSED, nil)
        OpenSSL::PKey::EC::Point.new(PolyPseudo.config.group, OpenSSL::BN.new(hex, 16))
      end
    ensure
      EC_POINT_free(sum_point)
    end

    def self.x_y(point)
      group     = EC_GROUP_new_by_curve_name(NID_brainpoolP320r1)
      point_hex = point.to_bn.to_s(16)
      point_pt  = EC_POINT_hex2point(group, point_hex, nil, nil)
      x_coord   = BN_new()
      y_coord   = BN_new()

      EC_POINT_get_affine_coordinates_GFp(group, point_pt, x_coord, y_coord, nil)

      [OpenSSL::BN.new(BN_bn2hex(x_coord), 16), OpenSSL::BN.new(BN_bn2hex(y_coord), 16)]
    ensure
      BN_free(x_coord)
      BN_free(y_coord)
    end

    def self.point2hex(point, compressed)
      group     = EC_GROUP_new_by_curve_name(NID_brainpoolP320r1)
      point_hex = point.to_bn.to_s(16)
      point_pt  = EC_POINT_hex2point(group, point_hex, nil, nil)
      EC_POINT_point2hex(group, point_pt, compressed ? POINT_CONVERSION_COMPRESSED : POINT_CONVERSION_UNCOMPRESSED, nil)
    end
  end
end

class OpenSSL::PKey::EC::Point
  def add(point)
    PolyPseudo::OpenSSLPointExtension.add(self, point)
  end

  def x
    PolyPseudo::OpenSSLPointExtension.x_y(self)[0]
  end

  def y
    PolyPseudo::OpenSSLPointExtension.x_y(self)[1]
  end

  def to_hex(compressed = true)
    PolyPseudo::OpenSSLPointExtension.point2hex(self, compressed)
  end
end
