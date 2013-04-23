module NodeWorker
  # Ugly, but is there another way to have a queue per node?
  extend ActiveSupport::Concern

  included do
    class << self; attr_accessor :node_classes; end
    self.node_classes = {}

    Node.nodes.each do |node|
      class_eval <<-RUBY, __FILE__, __LINE__ + 1
        node_class = class #{node.gsub(/[^a-z0-9]/, '_').camelize} < self
          include Sidekiq::Worker
          sidekiq_options :queue => self.name.underscore.gsub(/\\//, '.'), :backtrace => true

          def self.node
            "#{node}"
          end

          def perform(*args)
            unless Node.current_node == "#{node}"
              raise "Processing data for #{node}, but I'm #{Node.current_node}"
            end

            node_perform(*args)
          end

          self
        end

        self.node_classes["#{node}"] = node_class
      RUBY
    end
  end

  module ClassMethods
    def sidekiq_options(options)
      self.node_classes.values.each do |node_class|
        node_class.sidekiq_options(options)
      end
    end

    def perform_async(*args)
      raise "Nop, use perform_async_on_node"
    end

    def perform_async_on_node(node, *args)
      node_class = self.node_classes[node]
      raise "Node #{node} not registered?" unless node_class
      node_class.perform_async(*args)
    end
  end
end
