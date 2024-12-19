# frozen_string_literal: true

require 'set'

require_relative '../super_star'

class Node
  @@node_id = 0

  def initialize(stripe)
    @stripe = stripe
    @next = {}
    @id = @@node_id
    @@node_id += 1
  end

  def << stripe
    existing = @next[stripe]
    return existing unless existing.nil?

    new_node = Node.new(stripe)
    @next[stripe] = new_node
    new_node
  end

  def traverse(towel, i=0)
    return self if i >= towel.size

    stripe = towel[i]
    n = @next[stripe]
    return nil if n.nil?

    n.traverse(towel, i+1)
  end

  def to_s
    "[#@stripe]"
  end

  def final?
    @next.empty?
  end

  def count_possible_with(towels)
    @@found = Set.new
    count = foo(towels)
    @@found.size
  end

  def foo(towels)
    if final?
      @@found << @id
      return 1
    end

    count = 0
    towels.each do |towel|
      d = traverse(towel)

      next if d.nil?
      if d.final?
        @@found << @id if d.is_towel?(towels)
        return 1
      else
        count += d.foo(towels)
      end
    end

    count
  end
end

class Star < SuperStar
  def initialize
    super(19, 1)

    @possible_designs = Set.new
  end

  def run(input)
    towels = []
    designs = Node.new('')

    input.each_line do |line|
      case line
      when /.*,.*/
        towels = line.split(', ')
      when /^$/
        # Skip
      else
        node = designs
        line.each_char do |stripe|
          node = node << stripe
        end
        #node << '#'
      end
    end

    designs.count_possible_with towels
  end

  private

  #  def design_possible_with?(design, towels)
#    return true if design.empty? or @possible_designs.include?(design)
#    towels.each do |towel|
#      if design.start_with? towel
#        if design_possible_with? design[towel.size..-1], towels
#          @possible_designs << design
#          return true
#        end
#      end
#    end
#
#    false
#  end
end