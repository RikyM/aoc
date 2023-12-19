#!/usr/bin/env ruby

input_file = ARGV[0]

input = File.read(input_file)

def log message
  STDERR.puts message
end

class Part
  attr_reader :x, :m, :a, :s

  def initialize description
    fields = description[1..-2].split(?,)
    @x = fields[0][2..-1].to_i # Not nice, but it works well
    @m = fields[1][2..-1].to_i
    @a = fields[2][2..-1].to_i
    @s = fields[3][2..-1].to_i
  end

  def rating
    @x + @m + @a + @s
  end
end

class WfResult
  attr_reader :final, :accepted, :next_wf

  def initialize str
    if str == 'A'
      @final = true
      @accepted = true
      @next_wf = nil
    elsif str == 'R'
      @final = true
      @accepted = false
      @next_wf = nil
    else
      @final = false
      @accepted = nil
      @next_wf = str.to_sym
    end
  end
end

class Operation
  attr_reader :target

  def initialize operation, target
    @target = WfResult.new target

    @evaluation = build_operation operation
  end

  def evaluate part
    @evaluation.call(part)
  end

  private

  def build_operation operation
    property = operation[0]
    opcode   = operation[1]
    value    = operation[2..-1].to_i

    if opcode == ?>
      return -> (part) {part.send(property) > value}
    else
      return -> (part) {part.send(property) < value}
    end
  end
end

class NoOp < Operation
  def initialize target
    @target = WfResult.new target
  end

  def evaluate part
    true
  end
end

class Workflow
  attr_reader :name
  def initialize description
    name, instructions = description.chop.chop.split ?{
    @name = name.to_sym

    @operations = []
    instructions.split(?,).each do |ins|
      operands = ins.split(?:)

      if operands.size == 1
        @operations << NoOp.new(operands[0])
      else
        @operations << Operation.new(*operands)
      end
    end
  end

  def run part, wf_list
    @operations.each do |op|
      if op.evaluate(part)
        res = op.target

        if res.final
          return res.accepted ? part.rating : 0
        end

        return wf_list[res.next_wf].run(part, wf_list)
      end
    end

    raise 'Something went wrong'
  end
end

workflows = {}

total_rating = 0
input.each_line do |l|
  case l[0]
  when '{'
    p = Part.new l.chomp

    total_rating += workflows[:in].run(p, workflows)
  when "\n"
    next
  else
    wf = Workflow.new l
    workflows[wf.name] = wf
  end
end


puts total_rating
