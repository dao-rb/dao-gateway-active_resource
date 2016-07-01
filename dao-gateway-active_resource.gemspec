lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dao/gateway/active_resource/version'

Gem::Specification.new do |spec|
  spec.name          = 'dao-gateway-active_resource'
  spec.version       = Dao::Gateway::ActiveResource::VERSION
  spec.authors       = ['llxff', 'ssnikolay']
  spec.email         = ['ll.wg.bin@gmail.com']

  spec.summary       = 'Gateway for Active Resource'
  spec.description   = 'Gateway for Active Resource'
  spec.homepage      = 'https://github.com/dao-rb/dao-gateway-active_resource'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'dao-gateway', '~> 1.0'
  spec.add_dependency 'activeresource', '>= 4.1'

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.4'
  spec.add_development_dependency 'rspec-its'
  spec.add_development_dependency 'dao-entity', '~> 1.0'
  spec.add_development_dependency 'codeclimate-test-reporter'
end
