class TreeConstructor
  def initialize(root_node = nil)
    @root_node = root_node
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
