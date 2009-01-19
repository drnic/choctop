module Choctop::Appcast
  def make_dmg
    sh "hdiutil create -volname '#{name}' -srcfolder 'build/Release/#{target}' '#{pkg}'"
  end
  
  def make_appcast
    app_name = File.basename(File.expand_path('.'))
    
    FileUtils.mkdir_p "appcast/build"
    appcast = File.open("appcast/build/#{appcast_filename}", 'w')

    xml = Builder::XmlMarkup.new(:target => appcast, :indent => 2)

    xml.instruct!
    xml.rss('xmlns:atom' => "http://www.w3.org/2005/Atom",
            'xmlns:sparkle' => "http://www.andymatuschak.org/xml-namespaces/sparkle", 
            :version => "2.0") do
      xml.channel do
        xml.title(app_name)
        xml.description('#{app_name} updates')
        xml.link(base_url)
        xml.language('en')
        xml.pubDate Time.now.to_s(:rfc822)
        # xml.lastBuildDate(Time.now.rfc822)
        xml.atom(:link, :href => "#{base_url}/#{appcast_filename}", 
                 :rel => "self", :type => "application/rss+xml")

        version_info.each do |version|
          guid = version.first
          items = version[1]
          file = "appcast/build/#{items['filename']}"
          title = "#{name} #{items['version']}"
          
          xml.item do
            xml.title(title)
            xml.description(items['description'])
            xml.pubDate(File.mtime(file))
            xml.enclosure(:url => "#{base_url}/#{items['filename']}", 
                          :length => "#{File.size(file)}", 
                          :type => "application/dmg",
                          :"sparkle:version" => items['version'])
            xml.guid(guid, :isPermaLink => "false")
          end
        end
      end
    end
  end

  def upload_appcast
    sh %{rsync -aCv appcast/build/ #{host}#{remote_dir}}
  end
  
end
Choctop.send(:include, Choctop::Appcast)
