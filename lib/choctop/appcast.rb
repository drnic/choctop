module Choctop::Appcast
  def make_build
    sh "xcodebuild -configuration Release"
  end
  
  def make_dmg
    FileUtils.rm_rf pkg
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

        xml.item do
          xml.title("#{name} #{version}")
          xml.tag! "sparkle:releaseNotesLink", release_notes_link
          xml.pubDate(File.mtime(pkg))
          xml.guid("#{name}-#{version}", :isPermaLink => "false")
          xml.enclosure(:url => "#{base_url}/#{target}", 
                        :length => "#{File.size(pkg)}", 
                        :type => "application/dmg",
                        :"sparkle:version" => version)
        end
      end
    end
  end

  def upload_appcast
    _host = host.blank? ? "" : "#{host}:"
    sh %{rsync -aCv appcast/build/ #{_host}#{remote_dir}}
  end
  
end
Choctop.send(:include, Choctop::Appcast)
