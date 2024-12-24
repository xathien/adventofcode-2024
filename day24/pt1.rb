require 'fc'
require 'set'

wire_rules = {}
wire_values = Hash.new { |h, k|
  op1, operator, op2 = wire_rules[k]
  h[k] = wire_values[op1].public_send(operator, wire_values[op2])
}
operators = {
  "XOR" => :^,
  "OR" => :|,
  "AND" => :&,
}

File.readlines('input')
  .map(&:strip)
  .each { |line|
    wire, value = line.split(": ")
    wire_values[wire] = value.to_i
  }

File.readlines('input2')
  .map(&:strip)
  .each { |line|
    op1, operator, op2, _, output = line.split(" ")
    wire_rules[output] = [op1, operators[operator], op2]
  }

zindex = 0
result = 0
loop do
  z_wire = "z%02d" % zindex
  break unless wire_rules.key?(z_wire)
  result |= wire_values[z_wire] << zindex
  zindex += 1
end

pp "Sum? #{result}"