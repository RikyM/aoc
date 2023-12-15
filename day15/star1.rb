#!/usr/bin/env ruby

input_file = ARGV[0]

input = File.read(input_file)

def log message
  STDERR.puts message
end

class String
  def hash
    h = 0
    each_char do |c|
      h += c.ord
      h *= 17
      h %= 256
    end
    return h
  end
end

puts input.lines[0].chomp.split(?,).map(&:hash).sum
