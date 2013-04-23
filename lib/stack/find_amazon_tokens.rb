class Stack::FindAmazonTokens < Stack::BaseTokenFinder

  def find_tokens(env)
    src_dir = env[:src_dir]
    aws = { :key => [], :secret => [] }
    lines = exec_and_capture('script/find_amazon_tokens',src_dir)
    lines.each_line do |line|
      #Rails.logger.info line
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
    aws.values.map { |v| v.uniq! }
    env[:amazon_tokens] = aws
  end
end
