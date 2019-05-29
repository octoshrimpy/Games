require 'nokogiri'
require 'open-uri'

url = ARGV[0].to_s
html = Nokogiri::HTML(open url)
text = html.at('body').inner_text
puts text
