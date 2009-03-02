module ChocTop::Appcast
  def make_build
    if ENV['NO_BUILD']
      puts "Skipping build task..."
    else
      sh "xcodebuild -configuration #{build_type}"
    end
  end
  
  def make_appcast
    app_name = File.basename(File.expand_path('.'))
    
    FileUtils.mkdir_p "#{build_path}"
    appcast = File.open("#{build_path}/#{appcast_filename}", 'w') do |f|
      xml = Builder::XmlMarkup.new(:indent => 2)
      xml.instruct!
      xml_string = xml.rss('xmlns:atom' => "http://www.w3.org/2005/Atom",
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
            xml.tag! "sparkle:releaseNotesLink", "#{base_url}/#{release_notes}"
            xml.pubDate Time.now.to_s(:rfc822) #(File.mtime(pkg))
            xml.guid("#{name}-#{version}", :isPermaLink => "false")
            xml.enclosure(:url => "#{base_url}/#{pkg_name}", 
                          :length => "#{File.size(pkg)}", 
                          :type => "application/dmg",
                          :"sparkle:version" => version,
                          :"sparkle:dsaSignature" => dsa_signature)
          end
        end
      end
      f << xml_string
    end
  end
  
  def make_index_redirect
    File.open("#{build_path}/index.php", 'w') do |f|
      f << %Q{<?php header("Location: #{pkg_relative_url}"); ?>}
    end
  end
  
  def make_release_notes
    File.open("#{build_path}/#{release_notes}", "w") do |f|
      template = File.read(release_notes_template)
      f << ERB.new(template).result(binding)
    end
  end
  
  def release_notes_content
    if File.exists?("release_notes.txt")
      File.read("release_notes.txt")
    else
      <<-TEXTILE.gsub(/^      /, '')
      h1. #{version} #{Date.today}
      
      h2. Another awesome release!
      TEXTILE
    end
  end
  
  def release_notes_html
    RedCloth.new(release_notes_content).to_html
  end

  def upload_appcast
    _host = host.blank? ? "" : "#{host}:"
    sh %{rsync #{rsync_args} #{build_path}/ #{_host}#{remote_dir}}
  end
  
  # Returns a file path to the dsa_priv.pem file
  # If private key + public key haven't been generated yet then
  # generate them
  def private_key
    unless File.exists?('dsa_priv.pem')
      puts "Creating new private and public keys for signing the DMG..."
      `openssl dsaparam 2048 < /dev/urandom > dsaparam.pem`
      `openssl gendsa dsaparam.pem -out dsa_priv.pem`
      `openssl dsa -in dsa_priv.pem -pubout -out dsa_pub.pem`
      `rm dsaparam.pem`
      puts <<-EOS.gsub(/^      /, '')
      
      WARNING: DO NOT PUT dsa_priv.pem IN YOUR SOURCE CONTROL
               Remember to add it to your ignore list
      
      EOS
    end
    File.expand_path('dsa_priv.pem')
  end
  
  def dsa_signature
    @dsa_signature ||= `openssl dgst -sha1 -binary < "#{pkg}" | openssl dgst -dss1 -sign "#{private_key}" | openssl enc -base64`
  end
end
ChocTop.send(:include, ChocTop::Appcast)
