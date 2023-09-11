require 'minitest/autorun'
require 'nokogiri'
require 'open-uri'

class Futomaki
  def self.extract_list_page(page, &)
    node = NodeBuilder.new.build(&)

    extractor = Extractor.new(page, node)
    extractor.extract
  end

  private

  class NodeBuilder
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


class TestFutomaki < Minitest::Test
  def test_extract_list_page
    body = File.read('test/fixtures/list_page.html')

    scraped_data = [
      {
       "author": "George Orwell",
       "title": "1984"
      },
      {
       "author": "Lev Tolstoy",
       "title": "War and Peace"
      }
    ]

    result = Futomaki.extract_list_page(body) do
      books "//table/tr" do
        author "./td[1]"
        title  "./td[2]"
      end
    end

    assert_equal scraped_data, result
  end
end
=begin
  def test_build_node
    page = File.read('test/fixtures/list_page.html')

    result = Futomaki.extract_list_page(page) do
      books "//table/tr" do
        author "./td[1]"
        title  "./td[2]"
      end
    end

    binding.irb
  end

  def test_extract_repeating_pattern
    page = File.read('test/fixtures/list_page.html')

    result = Futomaki.extract_list_page(page) do
      books "//table/tr"
    end

    assert result.to_s.include?('George Orwell')
  end



end


=begin

class Node
  name
  args
  child_nodes - array of `Node`s
end

book = Node.new('book', ['//table/tr'], &block)

title = Node.new('title', ['./td[2]'])
author = Node.new('author', ['./td[1]'])
book.child_nodes = [title, author]




list_page:

[
  {title:, link:, description:, pubDate:, enclosure:},
  {title:, link:, description:, pubDate:, enclosure:},
  {title:, link:, description:, pubDate:, enclosure:},
]

detail_page:

{
  title:,
  link:,
  description:,
  pubDate:,
  enclosure:,
  content:,
}

----

list_of_hashes = ParseService.extract_list_page(body, matcher: :xpath) do
  urls    "//div[@id='maindesc']/table[1]//tr[(position()>1) and (position() < last())]//a/@href"
  titles  "//div[@id='maindesc']/table[1]//tr[(position()>1) and (position() < last())]//a"
  job_ids "//div[@id='maindesc']/table[1]//tr[(position()>1) and (position() < last())]//td[1]"
end

hash = ParseService.extract_detail_page(body) do
  urls    "//div[@id='maindesc']/table[1]//tr[(position()>1) and (position() < last())]//a/@href"
  titles  "//div[@id='maindesc']/table[1]//tr[(position()>1) and (position() < last())]//a"
  job_ids "//div[@id='maindesc']/table[1]//tr[(position()>1) and (position() < last())]//td[1]"
end

=end
