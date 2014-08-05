if ENV['S3_HOST']
  require 's3'
  S3.__send__(:remove_const, :HOST)
  S3.__send__(:const_set,    :HOST, ENV['S3_HOST'])
end
