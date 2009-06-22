gem 'hoe', '>= 2.1.1'
require 'hoe'
gem 'newgem', '>= 1.5.0'
require 'newgem'
require './lib/choctop'

# Generate all the Rake tasks
# Run 'rake -T' to see list of generated tasks (from gem root directory)
$hoe = Hoe.spec 'choctop' do
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
  
  self.clean_globs |= %w[**/.DS_Store tmp *.log]
  path = (self.rubyforge_name == self.name) ? self.rubyforge_name : "\#{self.rubyforge_name}/\#{self.name}"
  self.remote_rdoc_dir = File.join(path.gsub(/^#{self.rubyforge_name}\/?/,''), 'rdoc')
  self.rsync_args = '-av --delete --ignore-errors'
  
end

require 'newgem/tasks' # load /tasks/*.rake
Dir['tasks/**/*.rake'].each { |t| load t }

# TODO - want other tests/tasks run by default? Add them to the list
task :default => [:features]
