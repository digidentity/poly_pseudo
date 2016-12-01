$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'poly_pseudo'

PolyPseudo.configure do |config|
  config.ffi_lib = '/usr/local/opt/openssl/lib/libssl.dylib'
end

require "minitest/reporters"
require 'minitest/autorun'
require 'pp'

Minitest::Reporters.use!

