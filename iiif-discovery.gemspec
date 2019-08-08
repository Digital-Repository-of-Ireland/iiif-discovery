version = File.read(File.expand_path('../VERSION', __FILE__)).strip

Gem::Specification.new do |spec|
  spec.name          = 'iiif-discovery'
  spec.version       = version
  spec.authors       = ['Stuart Kenny']
  spec.email         = ['stuart.kenny@tchpc.tcd.ie']
  spec.description   = 'API for working with IIIF Discovery activity streams.'
  spec.summary       = 'API for working with IIIF Discovery activity streams.'
  spec.license       = 'Apache-2.0'
  spec.homepage      = 'https://github.com/Digital-Repository-of-Ireland/iiif-discovery'

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(%r{^spec/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'multi_json'

  #spec.add_dependency 'osullivan'
  spec.add_dependency 'json'
  spec.add_dependency 'activesupport', '>= 3.2.18'
  spec.add_dependency 'faraday', '>= 0.9'
end
