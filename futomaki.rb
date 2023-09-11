require 'nokogiri'
require 'open-uri'
require './tree_constructor'
require './extractor'
require './node'

class Futomaki
  def self.extract_list_page(page, &)
    extractor(page, &).extract_list_page
  end

  def self.extract_detail_page(page, &)
    root_node = Node.new('root', nil, &)

    extractor(page, root_node, &).extract_detail_page
  end

  private

  def self.extractor(page, root_node = nil, &)
    node = root_node || TreeConstructor.new.build(&)
    Extractor.new(page, node)
  end
end
