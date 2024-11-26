#!/usr/bin/env ruby

input_file = ARGV[0]

input = File.read(input_file)

def log message
  STDERR.puts message
end

def process_input_line line
  line.chomp.split(/:\s*/)[1].gsub(/\s*/, '').to_i
end

def count_solutions max_time, record
  a = -1
  b = max_time
  c = -record
  
  delta = (b * b) - (4 * a * c)

  return 0 if delta < 0
  return 1 if delta == 0

  delta = Math.sqrt(delta)
  
  x1 = (-b + delta) / (2 * a)
  x2 = (-b - delta) / (2 * a)

  res = x2.floor - x1.ceil + 1
  res -= 1 if x1.to_i == x1
  res -= 1 if x2.to_i == x2

  res
end

time = process_input_line input.lines[0]
distance = process_input_line input.lines[1]

puts count_solutions time, distance
