module DmgHelper
  def choctop_add_file(file, position = [347, 65])
    in_project_folder do
      append_to_file "Rakefile", "$choctop.add_file '#{file}', :position=> #{position.inspect}"
    end
  end
  
  def choctop_add_root(position = [180, 65])
    in_project_folder do
      append_to_file "Rakefile", "$choctop.add_root :position=> #{position.inspect}"
    end
  end
  
  def choctop_add_link(name, url, position = [347, 272])
    in_project_folder do
      append_to_file "Rakefile", "$choctop.add_link #{url.inspect}, :name => #{name.inspect}, :position=> #{position.inspect}"
    end
  end
end
World(DmgHelper)
