# frozen_string_literal: true

require 'parallel'
require 'set'

require_relative '../super_star'

class Instruction
  def initialize name, cpu
    @name = name
    @cpu = cpu
    @cache = Set.new
  end

  def execute arg
  end

  def get_combo_arg arg
    case arg
    when 4
      @cpu.a
    when 5
      @cpu.b
    when 6
      @cpu.c
    else
      arg
    end
  end
end

class InstructionAdv < Instruction
  def initialize cpu
    super('adv', cpu)
  end

  def execute arg
    op2 = get_combo_arg(arg)
    @cpu.a = @cpu.a >> op2
    nil
  end
end

class InstructionBxl < Instruction
  def initialize cpu
    super('bxl', cpu)
  end

  def execute arg
    @cpu.b = @cpu.b ^ arg
    nil
  end
end

class InstructionBst < Instruction
  def initialize cpu
    super('bst', cpu)
  end

  def execute arg
    @cpu.b = get_combo_arg(arg) % 8
    nil
  end
end

class InstructionJnz < Instruction
  def initialize cpu
    super('jnz', cpu)
  end

  def execute arg
    @cpu.ip = arg - 2 if @cpu.a != 0
    nil
  end
end

class InstructionBxc < Instruction
  def initialize cpu
    super('bxc', cpu)
  end

  def execute arg
    @cpu.b = @cpu.b ^ @cpu.c
    nil
  end
end

class InstructionOut < Instruction
  def initialize cpu
    super('out', cpu)
  end

  def execute arg
    get_combo_arg(arg) % 8
  end
end

class InstructionBdv < Instruction
  def initialize cpu
    super('bdv', cpu)
  end

  def execute arg
    @cpu.b = @cpu.a >> get_combo_arg(arg)
    @cpu.output_n += 1
    nil
  end
end

class InstructionCdv < Instruction
  def initialize cpu
    super('cdv', cpu)
  end

  def execute arg
    @cpu.c = @cpu.a >> get_combo_arg(arg)
    nil
  end
end

class Cpu
  attr_accessor :a, :b, :c, :ip, :output_n
  def initialize a=0, code = []
    #@registers = {}
    @a = a
    @b = 0
    @c = 0
    @ip = 0
    @code = code
    @output_n = 0
    #@output = []

    @isa = [
      InstructionAdv.new(self),
      InstructionBxl.new(self),
      InstructionBst.new(self),
      InstructionJnz.new(self),
      InstructionBxc.new(self),
      InstructionOut.new(self),
      InstructionBdv.new(self),
      InstructionCdv.new(self)
    ]
  end

  def load_code(code)
    @code = code
  end

  def reset a=0
    @ip = 0
    @a = a
    @b = 0
    @c = 0
  end

  def jump(address)
    @ip = address - 2
  end

  def execute_step
    op = @code[@ip]
    arg = @code[@ip + 1]

    out = @isa[op].execute arg

    @ip += 2
    out
  end

  def run
    Enumerator.new do |yielder|
      while @ip < @code.size
        out = execute_step
        break if out == -1
        yielder << out unless out.nil?
      end
    end
  end
end

class Star < SuperStar
  def initialize
    super(17, 2)
  end

  def run(input)
    cpu = Cpu.new
    code = []

    input.each_line do |line|
      case line
      when /^Register/
        #register_name = line.gsub(/Register (.*?): .*/, '\1')
        #register_value = line.gsub(/Register .*?: (\d+).*/, '\1').to_i

        #cpu.write_register(register_name, register_value)
      when /^Program/
        code = line.gsub(/.*?:\s+/, '').split(?,).map(&:to_i)
        cpu.load_code code
      end
    end

    #start = 0
    thread_number = 16

    result = []
    a_value = 0
    Parallel.each(0...thread_number) do |tn|
      result << run_until_repeats(tn, (thread_number), code)
      raise Parallel::Kill
    end
    puts result.inspect


    a_value
  end

  def run_until_repeats start, skipping, code
    cpu = Cpu.new
    cpu.load_code code

    a_value = start
    loop do
      cpu.reset a_value

      output_length = -1
      while cpu.ip < code.length
        out = cpu.execute_step
        unless out.nil?
          output_length += 1
          break if out != code[output_length]
        end
      end



      if output_length+1 == code.size
         return a_value
       end

      a_value += skipping
    end
  end
end
