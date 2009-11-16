gem 'hoe', '>= 2.3.2'
require 'hoe'
gem 'newgem', '>= 1.5.0'
require 'newgem'
require './lib/choctop'

Hoe.plugin :newgem

Hoe.spec 'choctop' do
  developer 'Dr Nic Williams', 'drnicwilliams@gmail.com'
  developer 'Chris Bailey', 'chris@cobaltedge.com'

  extra_deps << ['activesupport']
  extra_deps << ['builder','>= 2.1.2']
  extra_dev_deps << ['newgem', ">= #{::Newgem::VERSION}"]
end

require 'newgem/tasks' # load /tasks/*.rake
Dir['tasks/**/*.rake'].each { |t| load t }

task :default => [:features]
