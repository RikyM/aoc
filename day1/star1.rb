#!/usr/bin/env ruby

input_file = ARGV[0]

input = File.read(input_file)

def log message
  STDERR.puts message
end

p input.lines.map{|l| l.gsub(/[a-z]/, '')}
    .map{|d| "#{d[0]}#{d[-2]}"}.map(&:to_i).sum
