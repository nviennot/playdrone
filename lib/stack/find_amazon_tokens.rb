class Stack::FindAmazonTokens < Stack::BaseTokenFinder

  use_git :branch => :amazon_tokens

  def find_tokens(src_dir)
    aws = { :key => [], :secret => [] }
    Dir["#{src_dir}/**/*.java"].each do |filename|
      File.open(filename) do |file|
        contents = File.read(file).encode!('UTF-8', 'UTF-8', :invalid => :replace)
        contents.each_line do |line|
          if line =~ /"([^",() ]{40})"/
            secret = $1
            if secret =~ /[0-9]/ && secret =~ /([A-Z].*){4}/ && secret =~ /([a-z].*){4}/
              aws[:secret] << secret
            end
          end

          if line =~ /\b(AKIA[^"]{16})\b/
            key = $1
            aws[:key] << key
          end
        end
      end
    end
    aws.values.map { |v| v.uniq! }
    aws
  end

end
