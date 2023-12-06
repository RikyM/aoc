#!/usr/bin/env ruby

input_file = ARGV[0]

input = File.read(input_file)

def log message
  STDERR.puts message
end

$numbers = {
  'zero' => '0',
  'one' => '1',
  'two' => '2',
  'three' => '3',
  'four' => '4',
  'five' => '5',
  'six' => '6',
  'seven' => '7',
  'eight' => '8',
  'nine' => '9'
}

def transform(l, i = 0)
  "#{first(l)}#{last(l)}"
end

def first(str, i = 0)
  n = to_number(str, i)

  return first(str, i+1) if n.nil?
  return n
end

def last(str, i = str.size)
  n = to_number(str, i)

  return last(str, i-1) if n.nil?
  return n
end

def to_number(str, i)
  $numbers.each do |k,v|
    return str[i] if str[i] == v
    return v if str[i..-1].start_with?(k)
  end

  return nil
end

puts input.lines
    .map{|l| transform(l)}
    .map(&:to_i)
    .sum
