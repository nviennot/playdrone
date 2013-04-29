class Stack::BaseTokenFinder < Stack::Base
  class << self
    attr_accessor :token_name, :token_filters, :random_threshold, :proximity
    def tokens(token_name, options={})
      @token_name        = "#{token_name}_token"
      @random_threshold  = options.delete(:random_threshold)
      @proximity         = options.delete(:proximity)
      @token_filters     = options
    end
  end

  def is_random(str)
    last_class = nil
    num_switches = 0
    str.split('').each do |char|
      case char
      when /[a-z]/
        num_switches += 1 if last_class != /[a-z]/
        last_class = /[a-z]/
      when /[A-Z]/
        num_switches += 1 if last_class != /[A-Z]/
        last_class = /[A-Z]/
      when /[0-9]/
        num_switches += 3 if last_class != /[0-9]/
        last_class = /[0-9]/
      end
    end
    num_switches.to_f / str.size > self.class.random_threshold
  end

  def extract_tokens(env, filters={})
    filter = /^src\/.*\.java$/
    env[:need_src].call(:include_filter => filter)
    src_dir = env[:src_dir]

    _regexps = filters.values
    regexps = filters.values.map { |r| Regexp.new(r) }

    proximity = self.class.proximity ? self.class.proximity : regexps.count + 1
    lines = exec_and_capture(["grep -E -C#{proximity} -R -h '#{_regexps.first}' #{src_dir}/src",
                              *_regexps[1..-1].map { |r| "grep -E -C#{proximity} '#{r}'" }].join(" | "))

    lines.split("\n").split("--").map do |group|
      regexps.map do |regexp|
        matches = group.map { |l| l =~ regexp; $1 }.flatten.compact
        matches = matches.select { |l| is_random(l) } if self.class.random_threshold
        break if matches.empty?
        matches.first
      end
    end.compact.uniq
  end

  def call(env)
    tokens = extract_tokens(env, self.class.token_filters)

    self.class.token_filters.keys.each_with_index do |key, index|
      key = "#{self.class.token_name}_#{key}"
      env[:app][key] = tokens.map { |t| t[index] }
    end
    env[:app]["#{self.class.token_name}_count"] = tokens.count

    @stack.call(env)
  end
end
