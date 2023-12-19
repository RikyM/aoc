#!/usr/bin/env ruby

input_file = ARGV[0]

input = File.read(input_file)

def log message
  STDERR.puts message
end

MIN = 1
MAX = 4000

class SimpleCondition
  attr_reader :var, :min, :max
  def initialize op, min=nil, max=nil, var=nil
    if min.nil?
      @var = op[0].to_sym

      @op  = op[1].to_sym

      if @op == :<
        @min = MIN
        @max = op[2..-1].to_i - 1
      else
        @min = op[2..-1].to_i + 1
        @max = MAX
      end
    else
      @op = op
      @min = min
      @max = max
      @var = var
    end
  end

  def negation
    if @op == :>
      SimpleCondition.new :<, MIN, @min-1, var
    else
      SimpleCondition.new :>, @max+1, MAX, var
    end
  end

  def and other
    case other
    when SimpleCondition
      return CompositeCondition.new.and(self).and(other)
    when CompositeCondition
      return other.and(self)
    else
      raise 'Wrong type for condition'
    end
  end
end

class CompositeCondition
  def initialize limits=nil
    if limits.nil?
      @limits = {
        x: {min: MIN, max: MAX},
        m: {min: MIN, max: MAX},
        a: {min: MIN, max: MAX},
        s: {min: MIN, max: MAX}
      }
    else
      @limits = limits
    end
  end

  def [] var
    @limits[var]
  end

  def and other
    case other
    when SimpleCondition
      res = {}
      @limits.each do |var, lim|
        if var == other.var
          res[var] = {
            min: [@limits[var][:min], other.min].max,
            max: [@limits[var][:max], other.max].min
          }
        else
          res[var] = {
            min: @limits[var][:min],
            max: @limits[var][:max]
          }
        end
      end

      return CompositeCondition.new res
    when CompositeCondition
      res = {}
      @limits.each do |var, lim|
        res[var] = {
          min: [@limits[var][:min], other[var][:min]].max,
          max: [@limits[var][:max], other[var][:max]].min
        }
      end
      return CompositeCondition.new res
    else
      raise 'Wrong type for condition'
    end
  end

  def count
    counts = @limits.map{|_,lim| lim[:max] - lim[:min] + 1}
    return 0 if counts.any? {|c| c <= 0}
    return counts.reduce(:*)
  end
end

class Node
  attr_accessor :accept, :false

  def initialize instruction
    fields = instruction.split ?:
    if fields.size == 1
      @true = fields[0].to_sym
    else
      @condition = SimpleCondition.new fields[0]
      @true = fields[1].to_sym
    end
    @false = nil

    @accept = false
    @final
  end

  def link workflows
    @true = workflows[@true]
  end

  def conditions
    return @conditions unless @conditions.nil?

    res = @true.conditions.map{|c| @condition.nil? ? c : c.and(@condition)}
    unless @false.nil?
      neg = @condition.negation
      neg = @condition.negation
      res += @false.conditions.map{|c| c.and(neg)}

    end

    @conditions = res.flatten

    return @conditions
  end
  
end

class EndNode < Node
  def initialize accept
    @conditions = accept ? [CompositeCondition.new] : []
  end

  def link workflows
  end
end

workflows = {
  A: EndNode.new(true),
  R: EndNode.new(false)
}
nodes = []

input.each_line do |l|
  case l[0]
  when '{'
  when "\n"
    next
  else
    name, instructions = l.chop.chop.split ?{

    prev_node = nil
    instructions.split(?,).each do |ins|
      node = Node.new ins
      if prev_node.nil?
        workflows[name.to_sym] = node
      else
        prev_node.false = node
      end

      prev_node = node
      nodes << node
    end
  end
end

nodes.each{|n| n.link workflows}

puts workflows[:in].conditions.map(&:count).sum
