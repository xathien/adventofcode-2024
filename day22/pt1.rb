require 'fc'
require 'set'
require 'matrix'

prune_mod = 16777216 # 2 ** 24
mult0 = 64 # 2 ** 6
div = 32 # 2 ** 5
mult1 = 2048 # 2 ** 11
seen_values = Hash.new { |h, k|
  next_val = (k ^ (k * mult0)) % prune_mod
  # Step 2
  next_val = (next_val ^ (next_val / div)) % prune_mod
  # Step 3
  next_val = (next_val ^ (next_val * mult1)) % prune_mod
  h[k] = next_val
}

sum = File.readlines('input')
  .map(&:strip)
  .sum { |line|
    2000.times.reduce(line.to_i) { seen_values[_1] }
  }

pp "Sum? #{sum}"