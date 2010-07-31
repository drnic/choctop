Then /^file "(.*)" in mounted volume has GetFileInfo (.*) "(.*)"/ do |file, file_info_type, value|
  flags = case file_info_type.to_sym
  when :type; "-t"
  when :alias; "-aa"
  when :"custom icon"; "-ac"
  end
  in_mounted_volume do
    `GetFileInfo #{flags} '#{file}'`.strip.should == value
  end
end

Then /^file "(.*)" in mounted volume is aliased to "\/(.*)"/ do |folder_alias, target|
  in_mounted_volume do
    disk_name = `pwd`.chomp.split("/").last # HACK and an ugly on at that
    folder_alias_url = `osascript #{File.join(File.dirname(__FILE__), "../support/get_folder_alias_target_url.scpt")} #{folder_alias} #{disk_name}`.chomp
    folder_alias_url.should == "file://localhost/#{target}/"
  end
end