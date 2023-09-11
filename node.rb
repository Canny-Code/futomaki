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
