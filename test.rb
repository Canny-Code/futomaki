require 'minitest/autorun'
require './futomaki'

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
