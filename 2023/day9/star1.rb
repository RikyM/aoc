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

  def next_value data=@observed_data
    last = [data.last]

    loop do
      new_data = []
      (data.size-1).times do |i|
        new_data << data[i+1] - data[i]
      end

      last << new_data.last
      data = new_data
      break if data.all?{|v| v == 0}
    end

    return last.sum
  end
end

puts input.lines.map{|l| History.new l}.map(&:next_value).sum
