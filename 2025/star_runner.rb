#!/usr/bin/env ruby

# frozen_string_literal: true

day = ARGV[0]
star = ARGV[1]

def die error_message
  STDERR.puts error_message
  exit 1
end

def die_with_usage
  STDERR.puts 'Usage:'
  STDERR.puts "  #{$0} [<day> <star>]"
  exit 2
end

def read_argument arg_name
  print "#{arg_name.capitalize}: "
  argument = gets.chomp

  die "#{arg_name} needs to be a number" if argument !~ /^\d+$/

  argument
end

if ARGV.empty?
  day = read_argument('day')
  star = read_argument('star')
elsif [day, star].any? {|arg| arg.nil? or arg !~ /^\d+$/}
  die_with_usage
end

puts "Executing Day #{day} Star #{star}..."
begin
  require_relative "src/stars/star_#{day.rjust(2, '0')}_#{star}"
rescue LoadError
  die "Can't find script"
end
puts "Result: #{Star.new.help_the_elves}"
