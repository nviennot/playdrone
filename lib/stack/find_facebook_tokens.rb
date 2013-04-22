class Stack::FindFacebookTokens < Stack::BaseTokenFinder

  use_git :branch => :facebook_tokens

  def find_tokens(src_dir)
    facebook = { :app_id => [], :app_secret => [] }
    Dir["#{src_dir}/**/*.java"].each do |filename|
      File.open(filename) do |file|
        contents = File.read(file).encode!('UTF-8', 'UTF-8', :invalid => :replace)
        contents.each_line do |line|
          if line =~ /"(\d{13,17})"/
            app_id = $1
            facebook[:app_id] << app_id
          end

          if line =~ /"([0-9a-f]{32})"/
            app_secret = $1
            facebook[:app_secret] << app_secret
          end
        end
      end
    end
    facebook.values.map { |v| v.uniq! }
    facebook
  end

end
