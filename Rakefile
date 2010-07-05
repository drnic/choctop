require "bundler"
Bundler.setup
Bundler.require :newgem

Hoe.plugin :newgem
Hoe.plugin :cucumberfeatures

h = Hoe.spec 'choctop' do
  developer 'Dr Nic Williams', 'drnicwilliams@gmail.com'
  developer 'Chris Bailey', 'chris@cobaltedge.com'
  developer 'Patrick Huesler', 'patrick.huesler@gmail.com'
end
h.spec.add_bundler_dependencies

task :default => [:features, :spec]
