#!/usr/bin/env ruby

#Adapted from http://pragmatig.wordpress.com/2009/06/17/quick-markdown-preview-for-github-readme/
#Added --firefox or -f parameter so that it won't open firefox each time, and you can just hit refresh instead.

raise "Usage:\nmarkdown <filename> [-f|--firefox]" unless ARGV[0]

require 'rubygems'
#e.g. rdiscount, gem install rdiscount (or any other bluecloth flavour...)
require 'markdown'

text = Markdown.new(File.read(ARGV[0])).to_html
File.open('/tmp/markdown.html','w'){|f| f.puts text}

if ARGV[1] == "--firefox" or ARGV[1]=="-f"
  exec "firefox /tmp/markdown.html"
end
