#!/usr/bin/env ruby

input_file = ARGV[0]

input = File.read(input_file)

def log message
  STDERR.puts message
end

class Gate
  attr_reader :output, :name

  def initialize outputs, name
    @name = name
    @outputs = outputs
    @outputs = {}
    @inputs = []
  end

  def link gates
    @outputs.map! do |out_name|
      gate = gates[out_name]
      raise 'stocazzo' if gate.nil?
      gate.add_input self
      gate
    end
  end

  def add_input gate
    @inputs << gate
  end

  def emit signal
    @output = signal
  end

  def execute source, signal
    raise 'Gate not implemented'
  end

  def send_signal source, signal
    log "#{source.name} -#{signal ? 'high' : 'low'}-> #{@name}"

    if execute(source, signal)
      @outputs.each{|g| g.send_signal self, @output}
    end
  end
end

class Broadcaster < Gate
  def execute source, signal
    emit false
    return true
  end
end

class FlipFlop < Gate
  def initialize outputs, name
    super
    @stored = false
  end

  def execute source, signal
    if (! signal)
      @stored = ! @stored
      emit @stored
      return true
    end

    return false
  end
end

class Conjunction < Gate
  def initialize outputs, name
    super
    @stored = {}
    @stored.default = false
  end

  def execute source, signal

    @output = @inputs.all?{|i| @stored[i]}

    emit @output
    return true

  end

  
end

class Module
end

gates = {
}

input.each_line do |circuit|
  gate, outputs = circuit.chomp.split(' -> ')

  gate_type = gate[0]
  gate_name = gate[1..-1].to_sym
  outputs = outputs.split(', ').map(&:to_sym)
  #log gate_type
  #log gate_name
  #log outputs.inspect

  case gate_type
  when 'b'
    gates[:broadcaster] = Broadcaster.new outputs, :broadcaster
  when '%'
    gates[gate_name] = FlipFlop.new outputs, gate_name
  when '&'
    gates[gate_name] = Conjunction.new outputs, gate_name
  else
    raise "Unknown gate #{gate_type}"
  end
end

gates.each_value{|g| g.link gates}

broadcaster = gates[:broadcaster]
#broadcaster = gates[:a]

1.times do |i|
  broadcaster.send_signal :button, false
end


puts -1
