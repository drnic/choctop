module ChocTop::Appcast
  def make_build
    sh "xcodebuild -configuration Release"
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
        xml.description("#{app_name} updates")
        xml.link(base_url)
        xml.language('en')
        xml.pubDate Time.now.to_s(:rfc822)
        # xml.lastBuildDate(Time.now.rfc822)
        xml.atom(:link, :href => "#{base_url}/#{appcast_filename}", 
                 :rel => "self", :type => "application/rss+xml")

        xml.item do
          xml.title("#{name} #{version}")
          xml.tag! "sparkle:releaseNotesLink", release_notes_link
          xml.pubDate Time.now.to_s(:rfc822) #(File.mtime(pkg))
          xml.guid("#{name}-#{version}", :isPermaLink => "false")
          xml.enclosure(:url => "#{base_url}/#{pkg_name}", 
                        :length => "#{File.size(pkg)}", 
                        :type => "application/dmg",
                        :"sparkle:version" => version)
        end
      end
    end
  end
  
  def make_index_redirect
    File.open("appcast/build/index.php", 'w') do |f|
      f << %Q{<?php header("Location: #{pkg_relative_url}"); ?>}
    end
  end

  def upload_appcast
    _host = host.blank? ? "" : "#{host}:"
    sh %{rsync -aCv appcast/build/ #{_host}#{remote_dir}}
  end
  
end
ChocTop.send(:include, ChocTop::Appcast)
