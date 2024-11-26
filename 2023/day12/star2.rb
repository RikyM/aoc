#!/usr/bin/env ruby

input_file = ARGV[0]

input = File.read(input_file)

def log message
  STDERR.puts message
end

class Record
  def initialize sym, num
    @sym = (0...5).map{|i| sym}.join(??)
    @num = (0...5).map{|i| num}.map{|x|x.split(?,)}.flatten.map(&:to_i)

    @limits = Hash.new {|h,k| h[k] = Hash.new()}
    @num.size.times do |i|
      t = @num[i+1..-1]

      @limits[i][:max] = @sym.size - t.sum - t.size - @num[i]
      @limits[i][:min] = @num[0...i].sum + i
    end

    @memo = {}
  end

  def count
    limit = @limits[0]
    count_inner 0, 0, -1
  end

  private

  def count_inner group_i, start_i, end_prev
    memo_key = (group_i * 1000000) + start_i
    res = @memo[memo_key]
    return res unless res.nil?

    group_size = @num[group_i]
    limit = @limits[group_i]

    min = [limit[:min], start_i].max

    if group_i >= @num.size-1
      return (min..limit[:max])
                .filter{|i| can_put?(group_size, i, end_prev) and clear?(i+group_size)}
                .count
    end

    res = (min..limit[:max])
              .filter{|i| can_put? group_size, i, end_prev}
              .map{|i| count_inner(group_i+1, i + group_size+1, i+group_size)}
              .sum
    @memo[memo_key] = res
    return res
  end

  def clear? start
    start <= @sym.size and @sym[start..-1].chars.all? {|x| x != ?#}
  end

  def can_put? size, start, end_prev
    @sym[start...start+size].chars.none? {|x| x == ?.} and
        ?# != @sym[start+size] and
        (start <= 0 or ?# != @sym[start-1]) and
        (size < 1 or @sym[end_prev+1...start].chars.none?{|x| x == ?#})
  end
end

puts input.lines.map{|l| Record.new(*l.chomp.split).count}.sum
