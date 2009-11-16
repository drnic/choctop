module DmgHelper
  def choctop_add_file(file, position = [347, 65])
    in_project_folder do
      append_to_file "Rakefile", "$choctop.add_file '#{file}', :position=> #{position.inspect}"
    end
  end
end
World(DmgHelper)
