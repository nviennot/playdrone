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

    filter_signatures(env, signature)
    @stack.call(env)
  end

  def parse_from_git(env, git)
    signature = MultiJson.load(git.read_file('signature.json')).symbolize_keys
    filter_signatures(env, signature)
    @stack.call(env)
  end

  def filter_signatures(env, signature)
    #manifest = Nokogiri::XML(env[:src_git].read_file('AndroidManifest.xml'))
    #icon_name = manifest.css('application').first.attr('android:icon').split('/').last rescue "icon"

    # blacklisted_filenames = [
      # "#{icon_name}\\.png$",
      # "ic_launcher\\.png$",
      # "\\.xml$",
    # ]
    #blacklisted_filenames_re = Regexp.new("(#{blacklisted_filenames.join('|')})")
    #asset_hashes = signature[:asset_hashes].map { |h| h.keys.first =~ blacklisted_filenames_re ? nil : h.values.first }.compact
    resources    = signature[:resources]

    #asset_hashes_blacklist = SimilarApp.blacklist(:sig_asset_hashes)
    resources_blacklist_100    = SimilarApp.blacklist(:sig_resources, 100)
    resources_blacklist_300    = SimilarApp.blacklist(:sig_resources, 300)
    resources_blacklist_1000   = SimilarApp.blacklist(:sig_resources, 1000)

    #env[:app].sig_asset_hashes = asset_hashes.reject { |s| asset_hashes_blacklist.include? s }
    env[:app].sig_resources_100    = resources.reject    { |s| resources_blacklist_100.include? s }
    env[:app].sig_resources_300    = resources.reject    { |s| resources_blacklist_300.include? s }
    env[:app].sig_resources_1000   = resources.reject    { |s| resources_blacklist_1000.include? s }

    #env[:app].sig_asset_hashes_count = env[:app].sig_asset_hashes.count
    env[:app].sig_resources_count_100    = env[:app].sig_resources_100.count
    env[:app].sig_resources_count_300    = env[:app].sig_resources_300.count
    env[:app].sig_resources_count_1000   = env[:app].sig_resources_1000.count
  end
end
