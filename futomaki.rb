require 'nokogiri'
require 'open-uri'

class Futomaki
  def self.extract_list_page(page, &)
    node = TreeConstructor.new.build(&)

    extractor = Extractor.new(page, node)
    extractor.extract
  end

  private

  class TreeConstructor
    def initialize
      @root_node = nil
    end

    def method_missing(method_name, *args, &)
      if @root_node.nil?
        @root_node = Node.new(method_name, args.first, &)
        instance_eval(&)
      else
        @root_node.add_child(method_name, args.first)
      end
    end

    def build(&)
      instance_eval(&)
      @root_node
    end
  end

  class Node
    attr_reader :name, :xpath_query, :child_nodes

    def initialize(name, xpath_query, &block)
      @name = name
      @xpath_query = xpath_query
      @block = block
      @child_nodes = []
    end

    def add_child(name, xpath_query)
      @child_nodes << Node.new(name, xpath_query)
    end
  end

  class Extractor
    def initialize(page, node)
      @doc = Nokogiri::HTML(page)
      @node = node
      @result = []
    end

    def extract
      repeating_elements = doc.xpath(node.xpath_query)

      repeating_elements.map do |repeating_element|
        h = {}

        node.child_nodes.each do |child_node|
          h[child_node.name] = repeating_element.xpath(child_node.xpath_query).text
        end

        result << h
      end
      result
    end

    private

    attr_reader :doc, :result, :node
  end
end
