# frozen_string_literal: true

require_relative '../super_star'

class Star < SuperStar
  def initialize
    super(22, 1)
  end

  def run(input)
    res = 0

    input.each_line do |line|
      seed = line.to_i
      2000.times { seed = next_secret(seed) }
      res += seed
    end

    res
  end

  def next_secret(seed)
    secret = seed
    secret = (secret ^ (secret << 6)) & 16777215
    secret = (secret ^ (secret >> 5)) & 16777215
    secret = (secret ^ (secret << 11)) & 16777215
    secret
  end
end