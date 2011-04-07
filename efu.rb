#!/usr/bin/env ruby

require 'rubygems'
require 'mechanize'

DEFAULT_PATTERNS = %w/avi jpg mp3 mp4 pdf ogg zip/
patterns = Array.new

agent = Mechanize.new
if patterns.empty? then
    patterns = DEFAULT_PATTERNS
end

def absolute_url(root, href)
  URI.parse(root).merge(href)
end

source_url = 'http://microbiology.columbia.edu/W3310_2010.html'
page = agent.get(source_url)
patterns.each do |pattern|
  page.links_with(:href => /\.#{pattern}$/).each do |link|
    puts absolute_url(source_url, link.href)
  end
end
