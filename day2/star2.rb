#!/usr/bin/env ruby

input_file = ARGV[0]

input = File.read(input_file)

def log message
  STDERR.puts message
end

def power(game)
  game.chomp
      .gsub(/.*: /, '')
      .split(/\s*;\s*/)
      .map{|extraction| colors extraction}
      .reduce({red: 0, green: 0, blue: 0}) do |a, b|
        {
          red: [a[:red], b[:red]].max,
          green: [a[:green], b[:green]].max,
          blue: [a[:blue], b[:blue]].max
        }
      end
      .values
      .reduce(:*)
end

def colors(extraction)
    colors = extraction.split(/\s*,\s*/)
              .map{|ex| n, col = ex.split; [col.to_sym, n.to_i]}
    colors = Hash[*(colors.flatten)]
    colors.default = 0
    return colors
end

puts input.lines.map{|game| power game}.sum
