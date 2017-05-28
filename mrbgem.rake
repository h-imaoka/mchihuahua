MRuby::Gem::Specification.new('mchihuahua') do |spec|
  spec.license = 'MIT'
  spec.author  = 'MRuby Developer'
  spec.summary = 'mchihuahua'
  spec.bins    = ['mchihuahua']

  spec.add_dependency 'mruby-print', :core => 'mruby-print'
  spec.add_dependency 'mruby-mtest', :mgem => 'mruby-mtest'
  spec.add_dependency 'mruby-yaml', :github => 'AndrewBelt/mruby-yaml'
  spec.add_dependency 'mruby-getopts', :mgem => 'mruby-getopts'
  spec.add_dependency 'mruby-env', :mgem => 'mruby-env'
  spec.add_dependency 'mruby-polarssl', :mgem => 'mruby-polarssl'
  spec.add_dependency 'mruby-io', :github => 'iij/mruby-io'
  spec.add_dependency 'mruby-dir', :github => 'iij/mruby-dir'

end
