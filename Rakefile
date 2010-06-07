gem 'hoe', '>= 2.3.2'
require 'hoe'
gem 'newgem', '>= 1.5.0'
require 'newgem'

Hoe.plugin :newgem

$hoe = Hoe.spec 'choctop' do
  developer 'Dr Nic Williams', 'drnicwilliams@gmail.com'
  developer 'Chris Bailey', 'chris@cobaltedge.com'
  developer 'Patrick Huesler', 'patrick.huesler@gmail.com'
  extra_deps << ['builder','>= 2.1.2']
  extra_dev_deps << ['newgem', ">= #{::Newgem::VERSION}"]
end

task :release do
  sh "gem push pkg/#{$hoe.name}-#{$hoe.version}.gem"
end

require 'newgem/tasks' # load /tasks/*.rake
Dir['tasks/**/*.rake'].each { |t| load t }

task :default => [:features]
