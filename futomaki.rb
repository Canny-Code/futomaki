require 'nokogiri'
require 'open-uri'
require './tree_constructor'
require './extractor'
require './node'

class Futomaki
  def self.extract_list_page(page, &)
    node = TreeConstructor.new.build(&)

    extractor = Extractor.new(page, node)
    extractor.extract
  end
end
