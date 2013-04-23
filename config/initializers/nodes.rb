# Using globals so we can reload the Node class without killing the values
$current_node = Socket.gethostbyname(Socket.gethostname).first
$nodes = YAML.load_file(Rails.root.join("config", "nodes.yml"))[Rails.env]
