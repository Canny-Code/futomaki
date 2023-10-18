class HTMLExtractor
  def initialize(page, node)
    @doc = Nokogiri::HTML(page)
    @node = node
  end

  def extract_list_page
    repeating_elements = doc.xpath(node.xpath_query)

    repeating_elements.each_with_object([]) do |repeating_element, result|
      result << extract_data_from(repeating_element)
    end
  end

  def extract_detail_page
    extract_data_from(doc)
  end

  private

  attr_reader :doc, :node

  def extract_data_from(html_element)
    {}.tap do |h|
      node.child_nodes.each do |child_node|
        h[child_node.name] = html_element.xpath(child_node.xpath_query).text
      end
    end
  end
end
