#!/usr/bin/env ruby

input_file = ARGV[0]

input = File.read(input_file)

def log message
  STDERR.puts message
end

def weight_load column
  total_score = 0
  max_score = column.size
  fixed_pos = -1

  column.each_with_index do |c, i|
    case c
    when 'O'
      total_score += (max_score - fixed_pos - 1)
      fixed_pos += 1
    when '#'
      fixed_pos = i
    end
  end

  total_score
end

puts input.lines.map(&:chomp).map(&:chars).transpose.map{|x|weight_load x}.sum
