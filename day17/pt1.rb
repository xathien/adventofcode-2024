require 'set'

a = File.read('input').strip!.split(",").first.to_i
b = 0
c = 0
out = []
until a.zero?
  b = a[0..2]
  b ^= 1
  c = a / (2 ** b)
  b ^= c ^ 4
  a >>= 3
  out << b % 8
end

pp "Output? #{out.join(',')}"