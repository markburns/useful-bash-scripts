#!/usr/bin/env ruby
#Util to show migrations in a nice to read format
#Highlights current version of db in red
#requires term-ansicolor gem
#usage - copy to your rails root, chmod +x lsm.rb , then ./lsm or ./lsm s to sort alphabetically

require 'date'
require 'rubygems'
require 'term/ansicolor'
include Term::ANSIColor

version = `rake db:version`
sort_alphabetically = ARGV[0] == "s"
show_filename = ARGV.index "-f"
time = version.split(":")[1]
current_version = time.chomp!.strip!
time = DateTime.parse(time).to_s
date = time.split("T")[0]
time = time.split("T")[1][0..7]
puts green
puts "Current version: " + date + " " + time
puts reset


list = `ls db/migrate`
arr = []
longest=0
list.each do |i|
  filename = i
  name= i[15..-5]
  time=i[0..13]
  longest = name.length if name.length > longest
  arr << [name,time, filename]
end

if sort_alphabetically
  arr.sort! do |a,b|
    a[0].downcase <=> b[0].downcase
  end
end

arr.each do |details|
  name,time, filename = details[0], details[1], details[2]
  name.gsub! "_"," "
  spaces=(longest - name.length)+5
  colorize = true if time==current_version

  time = DateTime.parse(time).to_s
  date = time.split("T")[0]
  time = time.split("T")[1][0..7]

  puts red if colorize
  display = name + (" "*spaces) + "| " + date + " " + time
  if show_filename
    display << ("   " + blue + filename + white )
  end

  puts display
  #reset colors
  if colorize
    colorize = false
    puts reset
  end
end


