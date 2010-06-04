# Make gems available
require 'rubygems'
# http://drnicutilities.rubyforge.org/map_by_method/
gem 'map_by_method'
require 'pp'
require 'map_by_method'
require 'to_activerecord'
require 'irb/completion'
require 'irb/ext/save-history'
require 'map_by_method'

# Dr Nic's gem inspired by
# http://redhanded.hobix.com/inspect/stickItInYourIrbrcMethodfinder.html
require 'what_methods'

# Pretty Print method
require 'pp'

# Awesome Print gem (gem install awesome_print)
require 'ap'

# Print information about any HTTP requests being made
require 'net-http-spy'



# 'lp' to show method lookup path
require 'looksee/shortcuts'

# Wirble is a set of enhancements for irb
# http://pablotron.org/software/wirble/README
# Implies require 'pp', 'irb/completion', and 'rubygems'
require 'wirble'
Wirble.init

# Enable colored output
Wirble.colorize

#
# Draw ASCII tables
require 'hirb'
require 'hirb/import_object'
Hirb.enable :output=>{'Object'=>{:class=>:auto_table, :ancestor=>true}}

extend Hirb::Console






# Load the readline module.
IRB.conf[:USE_READLINE] = true

# Remove the annoying irb(main):001:0 and replace with >>
IRB.conf[:PROMPT_MODE] = :SIMPLE

# Tab Completion
require 'irb/completion'

# Automatic Indentation
IRB.conf[:AUTO_INDENT]=true

# Save History between irb sessions
require 'irb/ext/save-history'
IRB.conf[:SAVE_HISTORY] = 100
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb-save-history"

# Clear the screen
def clear
system 'clear'
if ENV['RAILS_ENV']
return "Rails environment: " + ENV['RAILS_ENV']
else
return "No rails environment - happy hacking!";
end
end

# Shortcuts
alias c clear

# Load / reload files faster
# http://www.themomorohoax.com/2009/03/27/irb-tip-load-files-faster
def fl(file_name)
   file_name += '.rb' unless file_name =~ /\.rb/
   @@recent = file_name
   load "#{file_name}"
end

def rl
  fl(@@recent)
end

# Reload the file and try the last command again
# http://www.themomorohoax.com/2009/04/07/ruby-irb-tip-try-again-faster
def rt
  rl
  eval(choose_last_command)
end

# prevent 'rt' itself from recursing.
def choose_last_command
  real_last = Readline::HISTORY.to_a[-2]
  real_last == 'rt' ? @@saved_last : (@@saved_last = real_last)
end

# Method to pretty-print object methods
# Coded by sebastian delmont
# http://snippets.dzone.com/posts/show/2916
class Object
  ANSI_BOLD = "\033[1m"
  ANSI_RESET = "\033[0m"
  ANSI_LGRAY = "\033[0;37m"
  ANSI_GRAY = "\033[1;30m"


  # Print object's methods
  def pm(*options)
    methods = self.methods
    methods -= Object.methods unless options.include? :more
    filter = options.select {|opt| opt.kind_of? Regexp}.first
    methods = methods.select {|name| name =~ filter} if filter

    data = methods.sort.collect do |name|
      method = self.method(name)
      if method.arity == 0
        args = "()"
      elsif method.arity > 0
        n = method.arity
        args = "(#{(1..n).collect {|i| "arg#{i}"}.join(", ")})"
      elsif method.arity < 0
        n = -method.arity
        args = "(#{(1..n).collect {|i| "arg#{i}"}.join(", ")}, ...)"
      end
      klass = $1 if method.inspect =~ /Method: (.*?)#/
      [name, args, klass]
    end
    max_name = data.collect {|item| item[0].size}.max
    max_args = data.collect {|item| item[1].size}.max
    data.each do |item|
      print " #{ANSI_BOLD}#{item[0].to_s.rjust(max_name)}#{ANSI_RESET}"
      print "#{ANSI_GRAY}#{item[1].ljust(max_args)}#{ANSI_RESET}"
      print " #{ANSI_LGRAY}#{item[2]}#{ANSI_RESET}\n"
    end
    data.size
  end
end

# http://sketches.rubyforge.org/
require 'sketches'
#Sketches.config :editor => 'vim'

# Tell irb how much it should remember and where
# to save it's history
IRB.conf[:SAVE_HISTORY] = 100
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb-save-history"

# Simple prompt
IRB.conf[:PROMPT_MODE]  = :SIMPLE
IRB.conf[:AUTO_INDENT]=true

script_console_running = ENV.include?('RAILS_ENV') && IRB.conf[:LOAD_MODULES] && IRB.conf[:LOAD_MODULES].include?('console_with_helpers')
rails_running = ENV.include?('RAILS_ENV') && !(IRB.conf[:LOAD_MODULES] && IRB.conf[:LOAD_MODULES].include?('console_with_helpers'))
irb_standalone_running = !script_console_running && !rails_running

if script_console_running
  require 'logger'
if !Object.const_defined?('RAILS_DEFAULT_LOGGER')
  # log SQL to the Rails console
  Object.const_set('RAILS_DEFAULT_LOGGER', Logger.new(STDOUT))
end
end
#
# Easily print methods local to an object's class
class Object
  def methodz(obj=self)
    pp (obj.methods - Object.instance_methods).sort
  end
end
def history(how_many = 50)
  history_size = Readline::HISTORY.size

  # no lines, get out of here
  puts "No history" and return if history_size == 0

  start_index = 0

  # not enough lines, only show what we have
  if history_size <= how_many
    how_many  = history_size - 1
    end_index = how_many
  else
    end_index = history_size - 1 # -1 to adjust for array offset
    start_index = end_index - how_many
  end

  start_index.upto(end_index) {|i| print_line i}
  nil
end
alias :h  :history

# -2 because -1 is ourself
def history_do(lines = (Readline::HISTORY.size - 2))
  irb_eval lines
  nil
end
alias :h! :history_do

def history_write(filename, lines)
  file = File.open(filename, 'w')

  get_lines(lines).each do |l|
    file << "#{l}\n"
  end

  file.close
end
alias :hw :history_write

private
def get_line(line_number)
  Readline::HISTORY[line_number]
end

def get_lines(lines = [])
  return [get_line(lines)] if lines.is_a? Fixnum

  out = []

  lines = lines.to_a if lines.is_a? Range

  lines.each do |l|
    out << Readline::HISTORY[l]
  end

  return out
end

def print_line(line_number, show_line_numbers = true)
  print "[%04d] " % line_number if show_line_numbers
  puts get_line(line_number)
end

def irb_eval(lines)
  to_eval = get_lines(lines)

  eval to_eval.join("\n")

  to_eval.each {|l| Readline::HISTORY << l}
end



def enable_trace( event_regex = /^(call|return)/, class_regex = /IRB|Wirble|RubyLex|RubyToken/ )
  puts "Enabling method tracing with event regex #{event_regex.inspect} and class exclusion regex #{class_regex.inspect}"

  set_trace_func Proc.new{|event, file, line, id, binding, classname|
    printf "[%8s] %30s %30s (%s:%-2d)\n", event, id, classname, file, line if
      event          =~ event_regex and
      classname.to_s !~ class_regex
  }
  return
end

def disable_trace
  puts "Disabling method tracing"

  set_trace_func nil
end

