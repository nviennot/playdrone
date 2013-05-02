require 'nokogiri'
require 'digest/md5'

class Stack::Signature < Stack::BaseGit
  use_git :branch => :signature_v2

  def persist_to_git(env, git)
    signature = {}

    signature[:asset_hashes] = []
    signature[:resources]    = []

    env[:src_git].read_files(:include_filter => /^(res|assets)/) do |filename, content|
      next unless content # directory
      signature[:asset_hashes] << { filename => Digest::MD5.hexdigest(content) }
    end

    public_xml = env[:src_git].read_file('res/values/public.xml')
    if public_xml
      signature[:resources] = Nokogiri::XML(public_xml).css('[name]').map do |node|
        node.attributes['name'].value
      end
    end
    signature[:resources].uniq!

    git.commit do |index|
      index.add_file('signature.json', MultiJson.dump(signature, :pretty => true))
    end

    match(env, signature)
    @stack.call(env)
  end

  def parse_from_git(env, git)
    signature = MultiJson.load(git.read_file('signature.json'), :symbolize_keys => true)
    match(env, signature)
    @stack.call(env)
  end

  def match(env, signature)
    # TODO
    env[:app].sig_asset_hashes = []
    env[:app].sig_resources    = []
  end
end
