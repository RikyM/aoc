# frozen_string_literal: true

require_relative '../../src/stars/star_02_1'
require_relative '../helper/test_star'

day = '2'
star_n = '2'

star = TestStar.new day, star_n

describe "Day #{day} - Star #{star_n}" do
  it 'Runs the example' do
    output = star.run_example
    expect(output).to eq(4174379265)
  end
end

describe "Range" do
  it "Finds 1 to be valid" do
    expect(Range.is_valid? 1).to be true
  end

  it "Finds 10 to be valid" do
    expect(Range.is_valid? 10).to be true
  end

  it "Finds 11 to be invalid" do
    expect(Range.is_valid? 11).to be false
  end

  it "Finds 111 to be invalid" do
    expect(Range.is_valid? 111).to be false
  end

  it "Finds 1188511885 to be invalid" do
    expect(Range.is_valid? 1188511885).to be false
  end

  describe 'n_digits' do
    it 'of 1 is 1' do
      expect(Range.n_digits 1).to be 1
    end

    it 'of 10 is 2' do
      expect(Range.n_digits 10).to be 2
    end

    it 'of 11 is 2' do
      expect(Range.n_digits 11).to be 2
    end

    it 'of 99 is 2' do
      expect(Range.n_digits 99).to be 2
    end

    it 'of 100 is 3' do
      expect(Range.n_digits 100).to be 3
    end
  end

  describe '11-22' do
    it 'has 2 invalid ids' do
      output = Range.from_string('11-22').invalids_sum
      expect(output).to eq(33)
    end
  end

  describe '95-115' do
    it 'has 2 invalid ids' do
      output = Range.from_string('95-115').invalids_sum
      expect(output).to eq(210)
    end
  end
end