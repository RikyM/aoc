#!/usr/bin/env ruby

input_file = ARGV[0]

input = File.read(input_file)

def log message
  STDERR.puts message
end

puts input.lines
          .map{|l| l.chomp.gsub(/^.*:\s*/, '')}
          .map{|l| l.split(/\s*\|\s*/).map{|s| (s.split /\s+/).map(&:to_i)}.reduce(&:&).size}
          .filter{|n| n > 0}
          .map{|n| 2 ** (n-1)}
          .sum
