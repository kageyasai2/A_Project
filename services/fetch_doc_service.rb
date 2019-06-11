require 'nokogiri'
require 'open-uri'
require 'addressable/uri'

class FetchDocService
  def initialize(url)
    @url = url
  end

  def execute
    fetch_html
  end

  private

  def fetch_html
    OpenURI.open_uri(@url) do |page|
      Nokogiri::HTML.parse(page.read, nil, page.charset)
    end
  end
end
