namespace :appcast do
  desc "Create/update the appcast file"
  task :build do
    require File.dirname(__FILE__) + "/../sparkle_tools"
    include SparkleTools::Appcast
    make_appcast
  end
  
  desc "Upload the appcast file to the server"
  task :upload do
    require File.dirname(__FILE__) + "/../sparkle_tools"
    include SparkleTools::Appcast
    upload_appcast
  end
end

