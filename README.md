# PolyPseudo

## Installation

Make sure you have installed OpenSSL 1.0.2+.

    $ brew install openssl

Add this line to your application's Gemfile:

```ruby
gem 'poly_pseudo'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install poly_pseudo

## Usage

```ruby
require 'poly_pseudo'

encoded_asn1 = <<-BASE64
MIIBVAYMYIQQAYdrg+MFAQIBAgEBAgEBFhQwMDAwMDAwNDAwMzIxNDM0NTAwMRYU
MDAwMDAwMDMyNzMyMjYzMTAwMDACBAEzok4wgfkEUQQdTrTmvUoznOB+4bGfted+
sc7mnN2M2k9T/c2ZXvOYf8CwniAsnxVgzTzsoEpg8NRJq6aBjFCyBz3NwOulwrNE
4/Q+2v0eE6R9Cvd8ngeL7QRRBEybIwRxjf6/9xWlMSg3aINSJf2GQaJjkp+uQudg
slmExVSUUidHeS4rRqh7MEiOulqAYF6UkvXFYCUGU7DRScIxGf8xPYmULaYnMSle
cpeMBFEElI6gAq+crdUFVzkF7bNFX+tEUIiGvc7daUbYpoatwogyGveoPvgOt3MC
t38iHgW3leqaRomZgNHbjQEgCCy/2VJgdwQYDSs/j++K1KtUMOgEEAAAAAAAAAAA
AAAAAAAAAAA=
BASE64

identity_or_pseudonym = PolyPseudo::PseudoId.from_asn1(encoded_asn1)

identity_key   = PolyPseudo::Util.read_key(File.read('EI_Decryption.pem'))
decryption_key = PolyPseudo::Util.read_key(File.read('EP_Decryption.pem'))
closing_key    = PolyPseudo::Util.read_key(File.read('EP_Closing.pem'))

case identity_or_pseudonym
when PolyPseudo::Identity
    identity_or_pseudonym.decrypt(identity_key)
when PolyPseudo::Pseudonym
    identity_or_pseudonym.decrypt(decryption_key, closing_key)
end

puts identity_or_pseudonym.pseudo_id
```

## Caveats

OpenSSL 1.0.2 is required.
On OSX the default openssl is not capable of handling the Brainpool curves. 
If you installed openssl via homebrew, chances are it's not correctly configured for FFI.
You will probably get a segmentation fault if you don't have the correct version.

You can configure the openssl library location using the config

```ruby
PolyPseudo.configure do |config|
  config.ffi_lib = '/usr/local/opt/openssl/lib/libssl.dylib'
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/digidentity/poly_pseudo.

