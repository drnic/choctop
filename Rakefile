require "bundler"
Bundler.setup
Bundler.require :newgem

Hoe.plugin :newgem
Hoe.plugin :cucumberfeatures

Hoe.spec 'choctop' do
  developer 'Dr Nic Williams', 'drnicwilliams@gmail.com'
  developer 'Chris Bailey', 'chris@cobaltedge.com'
  developer 'Patrick Huesler', 'patrick.huesler@gmail.com'
  add_bundler_dependencies
end

task :default => [:features, :spec]
