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
