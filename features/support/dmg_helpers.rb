module DmgHelper
  def choctop_add_file(file)
    position = [347, 65]
    in_project_folder do
      append_to_file "Rakefile", <<-RUBY.gsub(/^      /, '')
      $choctop.add_file "#{file}", :position=> #{position.inspect}
      RUBY
    end
  end
end
World(DmgHelper)
