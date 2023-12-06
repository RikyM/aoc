#!/usr/bin/env ruby

##############################
# Test Range stuff
##############################
#seeds = [Seed.new(82, 1)]
#m = Mapping.new 69, 70, 11
#log seeds.map{|s| s.map m}.inspect
#def try seed, mapping, expected
#  log " - Mapping: #{mapping.inspect}:"
#  res = mapping.intersect seed
#  log "    #{res.inspect} == #{expected.inspect}"
#  log "      #{res == expected}"
#end
#
#seed = Seed.new 10, 6
#log " == Seed: #{seed.inspect} =="
#mapping = Mapping.new  5, 1,  2
#try seed, Mapping.new( 5, 1,  2), {mapped:     nil,  not_mapped: []}
#try seed, Mapping.new( 5, 1,  8), {mapped: [10, 12], not_mapped: [[13, 15]]}
#try seed, Mapping.new( 5, 1, 30), {mapped: [10, 15], not_mapped: []}
#try seed, Mapping.new( 5, 1, 16), {mapped: [10, 15], not_mapped: []}
#try seed, Mapping.new(10, 1,  6), {mapped: [10, 15], not_mapped: []}
#try seed, Mapping.new(12, 1,  2), {mapped: [12, 13], not_mapped: [[10, 11], [14, 15]]}
#try seed, Mapping.new(11, 1,  3), {mapped: [11, 13], not_mapped: [[10, 10], [14, 15]]}
#try seed, Mapping.new(11, 1, 33), {mapped: [11, 15], not_mapped: [[10, 10]]}
#try seed, Mapping.new(16, 1,  1), {mapped:      nil, not_mapped: []}
#mappings = [
#  Mapping.new(100, 101, 1),
#  Mapping.new(12, 21,  2)
#]
#res = seed.map(mappings)
#log res.map(&:min).min.inspect
##############################
# End Test Range stuff
##############################

input_file = ARGV[0]

input = File.read(input_file)

def log message
  STDERR.puts message
end

class Seed
  def initialize n, range
    @n = n
    @range = range
  end

  def max
    @n + @range - 1
  end

  def min
    @n
  end

  def inspect
    "[#{min} -> #{max}]"
  end

  def map mappings
    res = self

    mappings.each do |m|
      ranges = m.intersect self

      next if ranges[:mapped].nil?

      res = ranges[:not_mapped]
            .map{|r| Seed.from_range r}
            .map{|m| m.map mappings}.flatten
      
      res << Seed.from_range(ranges[:mapped]).shift(m)

      break
    end


    return res
  end

  def self.from_range range
    Seed.new range[0], range[1]-range[0]+1
  end

  def shift mapping
    Seed.new @n + mapping.shift, @range
  end

  def to_s
    inspect
  end

  def to_i
    @n
  end
end

class Mapping
  def initialize target, source, range
    @source = source
    @target = target
    @range  = range
  end

  def max
    max = @source + @range - 1
  end

  def min
    @source
  end

  def shift
    @target - @source
  end

  def intersect seed
    res = {mapped: nil, not_mapped: []}

    if min <= seed.min
      if max >= seed.min
        res[:mapped] = [seed.min, [max, seed.max].min]
        res[:not_mapped] << [max + 1, seed.max] if max < seed.max
      end
    else
      if min <= seed.max
        res[:mapped] = [[seed.min, min].max, [seed.max, max].min]
        res[:not_mapped] << [seed.min, min-1]
        res[:not_mapped] << [max + 1, seed.max] if max < seed.max
      end
    end

    return res
  end

  def inspect
    "[#{min}, #{max}] -> [#{min+shift}, #{max+shift}]"
  end

  def map n
    @target - @source + n
  end

  def to_s
    inspect
  end
end

seeds = input.lines.first.split(?:)[1].split
s, n = *seeds.group_by.with_index {|s, i| i.odd?}.values.map{|a| a.map(&:to_i)}
seeds = s.zip(n).map{|sn| Seed.new sn[0], sn[1]}

mappings = []
(input.lines[3..-1]+['']).map(&:chomp).each do |l|
  case l
  when /[0-9]+ [0-9]+ [0-9]+/
    mappings << Mapping.new(*l.split.map(&:to_i))

  when /^$/
    seeds = seeds.map{|s| s.map mappings}.flatten

  else
    mappings = []
  end
  
end

puts seeds.map(&:min).min
