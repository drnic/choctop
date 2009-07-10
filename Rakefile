gem 'hoe', '>= 2.3'
require 'hoe'
gem 'newgem', '>= 1.5.0'
require 'newgem'
require './lib/choctop'

Hoe.plugin :newgem

Hoe.spec 'choctop' do
  developer 'Dr Nic Williams', 'drnicwilliams@gmail.com'
  developer 'Chris Bailey', 'chris@cobaltedge.com'
  
  self.extra_deps         = [
    ['activesupport'],
    ['builder','>= 2.1.2'],
    ['RedCloth', '>=4.1.1']
  ]
  self.extra_dev_deps = [
    ['newgem', ">= #{::Newgem::VERSION}"]
  ]
  
end

require 'newgem/tasks' # load /tasks/*.rake
Dir['tasks/**/*.rake'].each { |t| load t }

# TODO - want other tests/tasks run by default? Add them to the list
task :default => [:features]
