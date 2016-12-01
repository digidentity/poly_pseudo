module PolyPseudo
  class Config
    attr_accessor :group_name, :ffi_lib

    def initialize
      @group_name = 'brainpoolP320r1'
      @ffi_lib = 'ssl'
    end

    def group
      OpenSSL::PKey::EC::Group.new(group_name)
    end
  end
end
