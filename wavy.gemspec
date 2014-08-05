lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wavy/version'

Gem::Specification.new do |s|
  s.name          = 'wavy'
  s.version       = Wavy::VERSION

  s.summary       = "A simple templating engine for HTML."
  s.description   = "Wavy is a simple templating engine for HTML – Inspired By Sass"

  s.authors       = ["Matthew Govaere"]
  s.email         = 'matthew.govaere@gmail.com'
  s.homepage      = 'http://wavy.it'

  s.files         = Dir["lib/**/*"]
  s.executables   = ['wavy']

  s.license       = 'MIT'
end