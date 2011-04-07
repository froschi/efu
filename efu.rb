#!/usr/bin/env ruby

require 'rubygems'
require 'mechanize'

default_patterns = %w/avi jpg mp3 mp4 pdf ogg zip/
patterns = Array.new

agent = Mechanize.new
if patterns.empty? then
    patterns = default_patterns
end

page = agent.get('http://microbiology.columbia.edu/W3310_2010.html')
patterns.each do |pattern|
  page.links_with(:href => /\.#{pattern}$/).each do |link|
    puts link.uri
  end
end
