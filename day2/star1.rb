#!/usr/bin/env ruby

input_file = ARGV[0]

$max_cubes = {red: 12, green: 13, blue: 14}

input = File.read(input_file)

def log message
  STDERR.puts message
end

def possible?(game)
  extractions = game.chomp
                    .gsub(/.*: /, '')
                    .split(/\s*[,;]\s*/)
                    .map{|extraction| n, col = extraction.split; {color: col.to_sym, n: n.to_i}}

  ! $max_cubes.any?{|color,limit| extractions.filter{|ex| ex[:color] === color}.any?{|ex| ex[:n] > limit}}
end

def game_n(game)
  game.gsub(/Game /, '').to_i
end

puts input.lines.map{|l| possible?(l) ? game_n(l) : 0}.sum
