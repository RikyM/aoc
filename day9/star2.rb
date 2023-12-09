#!/usr/bin/env ruby

input_file = ARGV[0]

input = File.read(input_file)

def log message
  STDERR.puts message
end

class History
  def initialize str
    @observed_data = str.chomp.split.map(&:to_i)
  end

  def prev_value data=@observed_data
    first = [data.first]

    loop do
      new_data = []
      (data.size-1).times do |i|
        new_data << data[i+1] - data[i]
      end

      first << new_data.first
      data = new_data
      break if data.all?{|v| v == 0}
    end

    return first.reverse.reduce{|a,b| b-a}
  end
end

puts input.lines.map{|l| History.new l}.map(&:prev_value).sum
