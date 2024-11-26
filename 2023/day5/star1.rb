#!/usr/bin/env ruby

input_file = ARGV[0]

input = File.read(input_file)

def log message
  STDERR.puts message
end

class Seed
  def initialize n
    @n = n
  end

  def inspect
    @n
  end

  def map! mappings
    mapping = mappings.filter{|m| m.maps? @n}.first

    @n = mapping.map @n unless mapping.nil?
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

  def maps? n
    @source <= n and @source + @range >= n
  end

  def inspect
    "#@source -> #@target [#@range]"
  end

  def map n
    @target - @source + n
  end

  def to_s
    inspect
  end
end

seeds = input.lines.first.split(?:)[1].split.map{|i| Seed.new i.to_i}

mappings = []
(input.lines[3..-1]+['']).map(&:chomp).each do |l|
  case l
  when /[0-9]+ [0-9]+ [0-9]+/
    mappings << Mapping.new(*l.split.map(&:to_i))

    #log seeds.inspect
  when /^$/
    seeds.each{|s| s.map! mappings}
  else
    mappings = []
  end
  
end

puts seeds.map(&:to_i).min
