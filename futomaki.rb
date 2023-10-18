require 'nokogiri'
require 'open-uri'
require './tree_constructor'
require './html_extractor'
require './json_extractor'
require './node'

class Futomaki
  def self.extract_list_page(page, type: :HTML, &)
    extractor(page, type: type, &).extract_list_page
  end

  def self.extract_detail_page(page, type: :HTML, &)
    root_node = Node.new('root', nil, &)

    extractor(page, type: type, root_node: root_node, &).extract_detail_page
  end

  private

  def self.extractor(page, type:, root_node: nil, &)
    node = TreeConstructor.new(root_node).build(&)

    const_get("#{type}Extractor").new(page, node)
  end
end
