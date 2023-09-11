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

  def test_extract_detail_page
    body = File.read('test/fixtures/detail_page.html')

    scraped_data = {
      "author": "George Orwell",
      "title": "1984",
      "published": "1949",
      "description": "A dystopian novel set in Airstrip One, formerly Great Britain, a province of the superstate Oceania, whose residents are victims of perpetual war, omnipresent government surveillance and public manipulation."
    }

    result = Futomaki.extract_detail_page(body) do
      author "./p[@id='author']"
      title  "./p[@id='title']"
      published "./p[@id='published']"
      description "./p[@id='short-description']"
    end
  end
end
