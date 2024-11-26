#!/usr/bin/env ruby

input_file = ARGV[0]

input = File.read(input_file)

def log message
  STDERR.puts message
end


class String
  def hash
    h = 0
    each_char do |c|
      h += c.ord
      h *= 17
      h %= 256
    end
    return h
  end
end
  

class HashMap
  def initialize
    @hashmap = Hash.new {|h,k| h[k] = []}
  end

  def remove label
    @hashmap[label.hash].delete(label)
  end

  def put label, focal_length
    lenses = @hashmap[label.hash]
    l = lenses.find{|l| l == label}
    if l.nil?
      lenses << Lens.new(label, focal_length)
    else
      l.focal_length = focal_length
    end
  end

  def score
    @hashmap.map do |box,lenses|
      lenses.map.with_index do |lens, slot|
        (box + 1) * (slot+1) * lens.focal_length
      end.sum
    end.sum
  end
end


class Lens
  attr_reader :label, :focal_length

  def initialize label, focal_length
    @label = label
    @focal_length = focal_length.to_i
  end

  def focal_length= fl
    @focal_length = fl.to_i
  end

  def == other
    case other
    when Lens
      @label == other.label
    when String
      @label == other
    else
      false
    end
  end
end


hashmap = HashMap.new

input.lines[0].chomp.split(?,).each do |lens|
  label, focal_length = *lens.split(/[=-]/)

  if focal_length.nil?
    hashmap.remove label 
  else
    hashmap.put label, focal_length
  end
end

puts hashmap.score
