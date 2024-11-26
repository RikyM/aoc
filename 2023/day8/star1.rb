#!/usr/bin/env ruby

START_NODE = 'AAA'
END_NODE = 'ZZZ'


input_file = ARGV[0]

input = File.read(input_file)

def log message
  STDERR.puts message
end

directions = input.lines.first.chomp.split('').map(&:to_sym)

class Node
  attr_reader :name
  attr_accessor :left, :right
  def initialize name
    @name = name
    @left = nil
    @right = nil
  end

  def inspect
    "#@name[#{@left.name}, #{@right.name}]"
  end
end

nodes = Hash.new{|h,k| h[k] = Node.new k}

input.lines.drop(2).each do |line|
  source_name, targets = line.chomp.split(' = ')

  source = nodes[source_name]

  target_left, target_right = targets[1..-2].split(', ')

  source.left  = nodes[target_left]
  source.right = nodes[target_right]
end

steps = 0

node = nodes[START_NODE]

until node.name == END_NODE
  dir = directions[steps % directions.size]

  node = dir == :L ? node.left : node.right

  steps += 1
end

puts steps
