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

File.readlines('input2_corrected')
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

# x = 29500648881839 ->  110101101010010100111101100100111111010101111
# y = 25335070483487 ->  101110000101011000111111000000110010000011111
# z = 55114892239566 -> 1100100010000001101111100100101110001011001110 # BAD Z
# z = 54835719365326 -> 1100011101111101101111100100101110001011001110
# bad zindexes  08 45 16 32 -- jbc mnv y08 x08 btj tmm jdh qrw
# bad operators  &  |  &  |
# Maybe bads: (dnc XOR rtp cdj) (kcv XOR pqv gfm) (btj XOR tmm mrb) (x38 XOR y38 dhm) (x38 AND y38 qjd)
# Attempting: (Swap z16 and mrb) (Swap z08 and cdj) (Swap z32 and gfm) (Swap dhm and qjd)
# 1100011101111101101111100100101110001011001110
# 1100011101111101101111100100101110001011001110
puts "FARD: " + ["z08", "z16", "z32", "cdj", "gfm", "mrb", "dhm", "qjd"].sort.join(",")
zindex = 0
x_result = 0
loop do
  z_wire = "x%02d" % zindex
  break unless wire_values.key?(z_wire)
  x_result |= wire_values[z_wire] << zindex
  zindex += 1
end

zindex = 0
y_result = 0
loop do
  z_wire = "y%02d" % zindex
  break unless wire_values.key?(z_wire)
  y_result |= wire_values[z_wire] << zindex
  zindex += 1
end

def recurse_rules(wires, wire_rules, depth = 1, operator_acc = {}, wire_acc = {})
  until wires.empty?
    operator_acc[depth] = level = []
    wire_acc[depth] = wire_level = []
    wires = wires.flat_map { |wire|
      op1, operator, op2 = rule = wire_rules[wire]
      next [] unless rule
      level << operator
      wire_level << [op1, op2]
      [op1, op2]
    }
    depth += 1
  end
  operator_acc.delete(depth-1)
  [operator_acc, wire_acc]
end

operator_patterns = (0..45).each { |z_val|
  z_wire = "z%02d" % z_val
  operator_patterns, wire_levels = recurse_rules([z_wire], wire_rules)
  puts "Patterns for #{z_val}: #{operator_patterns.length} #{operator_patterns}"
  depth, last_l = operator_patterns.to_a.last
  puts "HOLY FREAKING CRAP1 #{depth} #{last_l}" unless depth == 1 || depth == z_val * 2
  puts "HOLY FREAKING CRAP2 #{last_l}" unless depth == 1 || last_l.sort == [:&, :^]
  operator_patterns.each_with_index { |(depth, ops), i|
    sorted_ops = ops.sort
    i += 1 if z_val == 45
    puts "HOLY FREAKING CRAP3 #{ops}" if i == 0 && sorted_ops != [:^]
    if i > 1 && i < operator_patterns.size - 1 && i % 2 == 0 && sorted_ops != [:&, :&]
      puts "HOLY FREAKING CRAP4 #{depth} #{ops} #{wire_levels[depth]}"
    end
    puts "HOLY FREAKING CRAP5 #{depth} #{ops} #{wire_levels[depth]}" if i > 0 && i < operator_patterns.size - 1 && i % 2 == 1 && sorted_ops != [:^, :|]
  }
}
# puts "All involved wires: (#{involved_wires.size})#{involved_wires}"

# puts "Initial X #{x_result} Y #{y_result}"

# puts "Wires actually involved in the addition: (#{wire_values.keys.size}) #{wire_values.keys}"
pp "Sum? #{result} -> #{result.to_s(2)}"