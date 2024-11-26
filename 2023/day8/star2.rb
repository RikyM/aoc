#!/usr/bin/env ruby

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

    @ending = name.end_with? ?Z
  end

  def is_ending_node?
    @ending
  end

  def to_s
    @name
  end

  def inspect
    "#@name[#{@left.name}, #{@right.name}]"
  end

  def count_steps_to_end directions
    node = self
    steps = 0

    until node.is_ending_node?
      dir = directions[steps % directions.size]

      node = dir == :L ? node.left : node.right

      steps += 1

      raise 'Timeout' if steps > 10000000 # Just to be sure...
    end

    return steps
  end
end

nodes = Hash.new{|h,k| h[k] = Node.new k}
starting_nodes = []

input.lines.drop(2).each do |line|
  source_name, targets = line.chomp.split(' = ')

  source = nodes[source_name]

  target_left, target_right = targets[1..-2].split(', ')

  source.left  = nodes[target_left]
  source.right = nodes[target_right]

  starting_nodes << source if source_name.end_with? ?A
end

end_steps = starting_nodes.map{|n| n.count_steps_to_end directions}
puts end_steps.reduce(&:lcm)
