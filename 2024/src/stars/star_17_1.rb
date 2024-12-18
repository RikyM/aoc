# frozen_string_literal: true

require_relative '../super_star'

class Instruction
  def initialize name, cpu
    @name = name
    @cpu = cpu
  end

  def execute arg
  end

  def get_combo_arg arg
    return arg if arg < 4
    @cpu.read_register ('A'.ord + arg - 4).chr
  end
end

class InstructionAdv < Instruction
  def initialize cpu
    super('adv', cpu)
  end

  def execute arg
    op1 = @cpu.read_register('A')
    op2 = get_combo_arg(arg)
    res = op1 / (2 ** op2)
    @cpu.write_register('A', res)
  end
end

class InstructionBxl < Instruction
  def initialize cpu
    super('bxl', cpu)
  end

  def execute arg
    op1 = @cpu.read_register('B')
    op2 = arg
    res = op1 ^ op2
    @cpu.write_register('B', res)
  end
end

class InstructionBst < Instruction
  def initialize cpu
    super('bst', cpu)
  end

  def execute arg
    res = get_combo_arg(arg) % 8
    @cpu.write_register('B', res)
  end
end

class InstructionJnz < Instruction
  def initialize cpu
    super('jnz', cpu)
  end

  def execute arg
    if @cpu.read_register('A') != 0
      @cpu.jump(arg)
    end
  end
end

class InstructionBxc < Instruction
  def initialize cpu
    super('bxc', cpu)
  end

  def execute arg
    op0 = @cpu.read_register('B')
    op1 = @cpu.read_register('C')
    @cpu.write_register('B', op0 ^ op1)
  end
end

class InstructionOut < Instruction
  def initialize cpu
    super('out', cpu)
  end

  def execute arg
    op0 = get_combo_arg(arg)
    @cpu.write_output(op0 % 8)
  end
end

class InstructionBdv < Instruction
  def initialize cpu
    super('bdv', cpu)
  end

  def execute arg
    op1 = @cpu.read_register('A')
    op2 = get_combo_arg(arg)
    @cpu.write_register('B', op1 / (2 ** op2))
  end
end

class InstructionCdv < Instruction
  def initialize cpu
    super('cdv', cpu)
  end

  def execute arg
    op1 = @cpu.read_register('A')
    op2 = get_combo_arg(arg)
    @cpu.write_register('C', op1 / (2 ** op2))
  end
end

class Cpu
  def initialize
    @registers = {}
    @ip = 0
    @code = []
    @output = []

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

  def write_register(name, value)
    @registers[name] = value
  end

  def read_register(name)
    @registers[name]
  end

  def load_code(code)
    @code = code
  end

  def jump(address)
    @ip = address - 2
  end

  def execute_step
    op = @code[@ip]
    arg = @code[@ip + 1]

    @isa[op].execute arg

    @ip += 2
  end

  def write_output(value)
    @output << value
  end

  def run
    execute_step while @ip < @code.size
    @output
  end
end

class Star < SuperStar
  def initialize
    super(17, 1)
  end

  def run(input)
    cpu = Cpu.new

    input.each_line do |line|
      case line
      when /^Register/
        register_name = line.gsub(/Register (.*?): .*/, '\1')
        register_value = line.gsub(/Register .*?: (\d+).*/, '\1').to_i

        cpu.write_register(register_name, register_value)
      when /^Program/
        cpu.load_code line.gsub(/.*?:\s+/, '').split(?,).map(&:to_i)
      end
    end


    cpu.run.map(&:to_s).join(',')
  end
end