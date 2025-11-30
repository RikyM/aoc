# frozen_string_literal: true

require 'set'

require_relative '../super_star'

class Star < SuperStar
  def initialize
    super(22, 2)
  end

  def run(input)
    res = 0
    seqs = Hash.new {|h,k| h[k] = []}

    input.each_line do |line|
      seed = line.to_i
      seq = []
      prev_price = seed % 10
      seen = Set.new

      2001.times do |i|
        secret = next_secret(seed)

        price = secret % 10
        delta = price - prev_price

        seq = seq + [delta]
        if seq.size >= 4
          seq = seq[-4..-1]
          unless seen.include?(seq)
            seqs[seq] << price
            seen << seq
          end
        end

        seed = secret
        prev_price = price
      end
      res += seed

    end

    seqs.values.map(&:sum).max
  end

  def next_secret(seed)
    secret = seed
    secret = (secret ^ (secret << 6)) & 16777215
    secret = (secret ^ (secret >> 5)) & 16777215
    secret = (secret ^ (secret << 11)) & 16777215
    secret
  end
end
