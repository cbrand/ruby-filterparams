Gem::Specification.new do |s|
  s.name        = 'filterparams'
  s.version     = '0.9.2'
  s.date        = '2016-03-08'
  s.summary     = 'Parser for filterparams query parameters'
  s.description = 'Parses filter parameters compatible query parameters and returns an object ' +
    'which can be used to be mapped on top of a backend system. More information is available on Github ' +
    '( https://github.com/cbrand/ruby-filterparams ).'
  s.license     = 'MIT'
  s.authors     = ['Christoph Brand']
  s.email       = 'christoph@brand.rest'
  s.files       = Dir.glob('{bin,lib}/**/*') + %w{README.md LICENSE.txt}
  s.homepage    = 'https://github.com/cbrand/ruby-filterparams'

  s.add_development_dependency 'rspec', ['~> 3.4']
  s.add_development_dependency 'rake'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'simplecov-json'
  s.add_development_dependency 'simplecov-rcov'
  s.add_development_dependency 'rubocop-checkstyle_formatter'
  s.add_development_dependency 'ci_reporter_rspec'
  s.add_runtime_dependency 'parslet', ['~> 1.6', '>= 1.6.0']
end
