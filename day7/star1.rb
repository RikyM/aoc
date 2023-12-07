#!/usr/bin/env ruby

input_file = ARGV[0]

input = File.read(input_file)

def log message
  STDERR.puts message
end

class Hand
  attr_reader :cards, :bid

  @@card_values = {
    'T' => 10,
    'J' => 11,
    'Q' => 12,
    'K' => 13,
    'A' => 14
  }

  def initialize s
    fields = s.split(' ')
    @cards = fields[0].split('').map{|c| card_to_i c}
    @bid   = fields[1].to_i
  end

  def card_to_i card
    @@card_values[card] || card.to_i
  end

  def value
    combs = @cards.group_by{|c| c}.values.map(&:size).sort.join('')

    points = 0

    case combs
    when '5'
      points = 6
    when '14'
      points = 5
    when '23'
      points = 4
    when '113'
      points = 3
    when '122'
      points = 2
    when '1112'
      points = 1
    end

    return points
  end

  def <=> other
    v = value <=> other.value
    return v unless v == 0

    @cards.size.times do |i|
      v = @cards[i] <=> other.cards[i]
      return v unless v == 0
    end
  end
end

hands = input.lines.map{|l| Hand.new l}

puts hands.sort.map.with_index{|h, i| h.bid * (i+1)}.sum
