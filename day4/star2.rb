#!/usr/bin/env ruby

input_file = ARGV[0]

input = File.read(input_file)

def log message
  STDERR.puts message
end

$cards = {}

class Card
  attr_reader :id

  def initialize s
    @id = s.gsub(/Card\s*([0-9]+).*/, '\1').to_i

    score = s.gsub(/^.*:\s*/, '').split(/\s*\|\s*/).map{|s| (s.split /\s+/).map(&:to_i)}.reduce(&:&).size
    @wins = score > 0 ? (@id+1 .. @id+ score).to_a : []
  end

  def score(cards=$cards)
    return @score unless @score.nil?

    res = {@id => 1}
    ws = @wins.map{|w| cards[w]}
              .filter{|c| not c.nil?}
              .map{|c| c.score}

    @score = ws.reduce(res) {|a,b| Hash[*(a.keys | b.keys).map{|k| [k, (a[k] || 0) + (b[k] || 0)]}.flatten]}
  end
end

input.lines.each do |l|
  card = Card.new(l)
  $cards[card.id] = card
end

puts $cards.map{|id, card| card.score.values.sum}.sum
