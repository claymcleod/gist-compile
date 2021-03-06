Gem::Specification.new do |s|
  s.name        = 'gist-compile'
  s.version     = '1.0.1'
  s.date        = '2015-02-22'
  s.summary     = "Gist-compile will compile Github gists into an intelligible, book like, form."
  s.description = ""
  s.authors     = ["Clay McLeod"]
  s.email       = 'clay.l.mcleod@gmail.com'
  s.files       = `git ls-files`.split($\)
  s.executables = ['gist-compile']
  s.require_paths = ["lib"]                                     
  s.homepage    = 'http://github.com/claymcleod/gist-compile'
  s.license     = 'MIT'
  s.add_runtime_dependency 'thor', '~> 0.19.1', '>= 0.19.1'
  s.add_runtime_dependency 'paint', '~> 0.9.0', '>= 0.9'
  s.add_runtime_dependency 'nokogiri', '~> 1.6.6', '>= 1.6.6'
  s.add_runtime_dependency 'rest-client', '~> 1.7.2', '>= 1.7.2'
end
