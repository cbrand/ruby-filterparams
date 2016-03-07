Gem::Specification.new do |s|
  s.name        = 'filterparams'
  s.version     = '1.0.0'
  s.date        = '2016-03-03'
  s.summary     = ''
  s.description = ''
  s.authors     = ['Christoph Brand']
  s.email       = 'christoph@brand.rest'
  s.files       = Dir.glob('{bin,lib}/**/*')

  s.add_development_dependency 'rspec', ['~> 3.4']
  s.add_development_dependency 'rake'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'simplecov-json'
  s.add_development_dependency 'simplecov-rcov'
  s.add_development_dependency 'rubocop-checkstyle_formatter'
  s.add_runtime_dependency 'parslet', ['~> 1.6', '>= 1.6.0']
end
