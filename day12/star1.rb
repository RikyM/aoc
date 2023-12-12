#!/usr/bin/env ruby

input_file = ARGV[0]

input = File.read(input_file)

def count chars_head, chars_tail, to_check, current_block, prev = ''
  to_check_head, *to_check_tail = to_check

  if chars_head.nil?
    if (to_check_head || 0) == current_block and to_check.size < 2
      return 1
    else
      return 0
    end
  end


  chars_tail_head, *chars_tail_tail = chars_tail

  case chars_head
  when '.'
    if current_block > 0
      return 0 if current_block != to_check_head
      return count chars_tail_head, chars_tail_tail, to_check_tail, 0, prev + chars_head
    else
      return count chars_tail_head, chars_tail_tail, to_check, 0, prev + chars_head
    end
  when '#'
    if current_block > 0
      return count chars_tail_head, chars_tail_tail, to_check, current_block + 1, prev + chars_head
    else
      return count chars_tail_head, chars_tail_tail, to_check, current_block + 1, prev + chars_head
    end
  when '?'
    return (count '#', chars_tail, to_check, current_block, prev) + (count '.', chars_tail, to_check, current_block, prev)
  end
end

def log message
  STDERR.puts message
end

n = input.lines.map do |l|
  record_sym, record_num = l.split
  record_num = record_num.split(?,).map(&:to_i)

  record_sym = record_sym.chars
  head, *tail = record_sym
  
  count head, tail, record_num, 0
end

puts n.sum
