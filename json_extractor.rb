require 'json'

class JSONExtractor
  def initialize(page, node)
    @doc = JSON.parse(page, symbolize_names: true)
    @node = node
  end

  def extract_list_page
    repeating_elements = node.query.empty? ? doc : doc[node.query]

    repeating_elements.each_with_object([]) do |repeating_element, result|
      result << extract_data_from(repeating_element)
    end
  end

  def extract_detail_page
    extract_data_from(doc)
  end

  private

  attr_reader :doc, :node

  def extract_data_from(repeating_element)
    {}.tap do |h|
      node.child_nodes.each do |child_node|
        h[child_node.name] = repeating_element[child_node.query]
      end
    end
  end
end
