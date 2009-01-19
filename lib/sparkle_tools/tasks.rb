namespace :appcast do
  desc "Create/update the appcast file"
  task :build do
    make_appcast
  end
  
  desc "Upload the appcast file to the server"
  task :upload do
    upload_appcast
  end
end
