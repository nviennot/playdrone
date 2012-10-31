librato = nil
begin
  librato = YAML.load_file(Rails.root.join("config", "librato.yml"))[Rails.env]
rescue Exception
end

Librato::Metrics.authenticate(librato['email'], librato['api_key']) if librato
