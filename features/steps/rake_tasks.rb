Given /^a zip build has been created$/ do
  in_project_folder do
    `touch appcast/build/#{@project_name.camelcase}-1.0.0.zip`
  end
end