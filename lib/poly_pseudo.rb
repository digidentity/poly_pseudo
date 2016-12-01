require 'openssl'
require 'base64'
require 'digest'
require 'ffi'

require 'poly_pseudo/version'
require 'poly_pseudo/util'
require 'poly_pseudo/config'
require 'poly_pseudo/key'
require 'poly_pseudo/pseudo_id'
require 'poly_pseudo/identity'
require 'poly_pseudo/pseudonym'

module PolyPseudo
  @@loaded = false
  def self.init!
    unless @@loaded
      require 'ext/openssl_ec'
      @@loaded = true
    end
  end

  def self.configure
    yield config
    PolyPseudo.init!
  end

  def self.config
    @@config ||= Config.new
  end
end
