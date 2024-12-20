# frozen_string_literal: true

require 'set'

require_relative '../super_star'

class Node
  def initialize(stripe)
    @stripe = stripe
    @next = {}
    @seen = false
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
    return 0 if @seen
    if final?
      @seen = true
      return 1
    end

    count = 0
    towels.each do |towel|
      d = traverse(towel)

      next if d.nil?
      count += d.count_possible_with(towels)
    end
    @seen = true

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
      end
    end

    designs.count_possible_with towels
  end
end