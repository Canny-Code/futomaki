require 'minitest/autorun'
require './futomaki'

class HTMLExtractorTest < Minitest::Test
  def test_extract_detail_page
    body = File.read('test/fixtures/html/detail_page.html')

    scraped_data = {
      "author": "George Orwell",
      "title": "1984",
      "published": "1949",
      "description": "Published in 1949, George Orwell's '1984' is a dystopian novel set in a totalitarian future where the state, led by Big Brother, exerts total control over every aspect of the citizens' lives. The narrative follows Winston Smith, who begins to rebel against the oppressive regime."
    }

    result = Futomaki.extract_detail_page(body) do
      author "//p[@id='author']"
      title  "//h1[@id='title']"
      published "//p[@id='published']"
      description "//p[@id='short-description']"
    end

    assert_equal scraped_data, result
  end

  def test_extract_list_page
    body = File.read('test/fixtures/html/list_page.html')

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

    result = Futomaki.extract_list_page(body) do
      books "//table/tr" do
        author "./td[1]"
        title  "./td[2]"
      end
    end

    assert_equal scraped_data, result
  end

  def test_non_existent_detail_page_element
    body = File.read('test/fixtures/html/detail_page.html')

    scraped_data = {
      "no_match": ""
    }

    result = Futomaki.extract_detail_page(body) do
      no_match  "//p[@id='no-match']"
    end

    assert_equal scraped_data, result
  end

  def test_non_existent_repeating_pattern
    body = File.read('test/fixtures/html/list_page.html')

    scraped_data = []

    result = Futomaki.extract_list_page(body) do
      no_match "//non-existent-element" do
        no_match_chid "./non-existent-element"
      end
    end

    assert_equal scraped_data, result
  end

  def test_existing_repeating_pattern_with_no_data_inside
    body = File.read('test/fixtures/html/list_page.html')

    scraped_data = [
      {
       "no_match": ""
      },
      {
       "no_match": ""
      },
      {
        "no_match": ""
       }
    ]

    result = Futomaki.extract_list_page(body) do
      books "//table/tr" do
        no_match "./td[3]"
      end
    end

    assert_equal scraped_data, result
  end

end
