Then /^file '(.*)' in mounted volume has GetFileInfo (.*) '(.*)'/ do |file, file_info_type, value|
  flags = case file_info_type.to_sym
  when :type; "-t"
  when :alias; "-aa"
  when :"custom icon"; "-ac"
  end
  in_mounted_volume do
    `GetFileInfo #{flags} '#{file}'`.strip.should == value
  end
end

Then /^file '(.*)' in mounted volume is aliased to '(.*)'/ do |file, target|
  in_mounted_volume do
    puts "TODO - how to get applescript to test this?"
  end
end