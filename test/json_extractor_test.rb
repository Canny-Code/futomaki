require 'minitest/autorun'
require './futomaki'

class JSONExtractorTest < Minitest::Test
  def test_extract_list_page
    body = File.read('test/fixtures/json/list_page.html')

    scraped_data = [
      {
       "author": "George Orwell",
       "title": "1984"
      },
      {
       "author": "Lev Tolstoy",
       "title": "War and Peace"
      },
      {
        "author": "",
        "title": "The Bible"
      }
    ]

    result = Futomaki.extract_list_page(body, type: :JSON) do
      books "" do
        author :author
        title  :title
      end
    end

    assert_equal scraped_data, result
  end
end
