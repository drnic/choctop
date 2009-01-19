Then %r{^remote folder '(.*)' is created} do |folder|
  FileUtils.chdir @remote_folder do
    File.exists?(folder).should be_true
  end
end

Then %r{^remote file '(.*)' (is|is not) created} do |file, is|
  FileUtils.chdir @remote_folder do
    File.exists?(file).should(is == 'is' ? be_true : be_false)
  end
end
