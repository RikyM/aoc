#!/usr/bin/env ruby

BUTTON_PRESSES = 1000

input_file = ARGV[0]

input = File.read(input_file)

def log message
  STDERR.puts message
end

class Gate
  attr_reader :output, :name

  def initialize outputs, name, signals
    @name = name
    @outputs = outputs
    @inputs = []
    @signals = signals
  end

  def link gates
    @outputs.map! do |out_name|
      gate = gates[out_name]
      gate.add_input self
      gate
    end
  end

  def add_input gate
    @inputs << gate
  end

  def emit signal
    @outputs.each {|o| @signals << {source: self.name, target: o, signal: signal}}
  end

  def execute source, signal
    raise 'Gate not implemented'
  end

  def execute source, signal
    raise 'Gate not implemented'
  end

  def receive_signal source, signal
    execute(source, signal)
  end
end

class Broadcaster < Gate
  def execute source, signal
    emit false
    return true
  end
end

class FlipFlop < Gate
  def initialize outputs, name, signals
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
  def initialize outputs, name, signals
    super
    @stored = {}
    @stored.default = false
  end

  def execute source, signal
    @stored[source] = signal
    output = @inputs.map{|i| @stored[i.name]}.reduce{|a,b| a and b}
    output = not(output)

    #output = (@stored.size != @inputs.size) and not(@stored.values.reduce(true) {|a,b| a and b})

    emit output
    return true

  end

  
end

class Mod < Gate
  def initialize name
    super([], name, nil)
  end

  def execute souce, signal
  end
end

gates = {}
signals = []

input.each_line do |circuit|
  gate, outputs = circuit.chomp.split(' -> ')

  gate_type = gate[0]
  gate_name = gate[1..-1].to_sym
  outputs = outputs.split(', ').map(&:to_sym)

  outputs.filter do |name|
    unless gates.include? name
        gate = Mod.new name
        gates[name] = gate
    end
  end

  case gate_type
  when 'b'
    gates[:broadcaster] = Broadcaster.new outputs, :broadcaster, signals
  when '%'
    gates[gate_name] = FlipFlop.new outputs, gate_name, signals
  when '&'
    gates[gate_name] = Conjunction.new outputs, gate_name, signals
  else
    raise "Unknown gate #{gate_type}"
  end
end

gates.each_value{|g| g.link gates}
broadcaster = gates[:broadcaster]

low = 0
high = 0
BUTTON_PRESSES.times do
  signals << {source: :button, signal: false, target: broadcaster}

  until signals.empty?
    sig = signals.shift
    break if sig.nil?
    if sig[:signal]
      low += 1
    else
      high += 1
    end
    sig[:target].receive_signal sig[:source], sig[:signal]
  end
end

puts low * high
