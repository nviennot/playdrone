class Stack::DownloadApk < Stack::Base
  commit :branch => :apk

  def commit(env, branch)
    apk_filename = "#{env[:app].id_version}.apk"
    apk_path     = env[:scratch].join(apk_filename)

    # TODO Download to apk_path

    branch.add_file(apk_filename, apk_path.read)

    env[:apk_path] = apk_path
  end
end
