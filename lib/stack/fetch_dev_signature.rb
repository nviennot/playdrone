class Stack::FetchDevSignature < Stack::BaseGit
  use_git :branch => :dev_signature

  def persist_to_git(env, git)
    require 'zip'
    env[:need_apk].call

    signature = nil

    Zip::File.open(env[:apk_path]) do |z|
      sig_zip_path = z.entries.map(&:name).grep(/^META-INF\/*.+(RSA|DSA)$/).first
      sig_file = env[:scratch].join('dev_signature')
      File.open(sig_file, "wb") { |f| f.write z.read(sig_zip_path) }
      sig = `cat #{sig_file} | keytool -printcert | grep "MD5: "`
      raise "Bad matching" unless sig.chomp.match(/.*MD5:\s+(.+)$/)
      signature = $1.gsub(/:/, '')
      raise "Bad Signature" unless signature.size == 32
    end

    git.commit do |index|
      index.add_file('dev_signature', "#{signature}\n")
    end

    env[:app][:dev_signature] = signature

    @stack.call(env)
  end

  def parse_from_git(env, git)
    signature = git.read_file('dev_signature').chomp
    env[:app][:dev_signature] = signature
    @stack.call(env)
  end
end
