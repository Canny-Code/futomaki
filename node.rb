class Node
  attr_reader :name, :query, :child_nodes

  def initialize(name, query, &block)
    @name = name
    @query = query
    @block = block
    @child_nodes = []
  end

  def add_child(name, query)
    @child_nodes << Node.new(name, query)
  end
end
