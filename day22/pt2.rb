require 'fc'
require 'set'
require 'matrix'

prune_mod = 16777216 # 2 ** 24
mult0 = 64 # 2 ** 6
div = 32 # 2 ** 5
mult1 = 2048 # 2 ** 11
next_vals = Hash.new { |h, k|
  next_val = (k ^ (k * mult0)) % prune_mod
  # Step 2
  next_val = (next_val ^ (next_val / div)) % prune_mod
  # Step 3
  next_val = (next_val ^ (next_val * mult1)) % prune_mod
  h[k] = next_val
}

pattern_prices = Hash.new(0)

File.readlines('input')
  .map { _1.strip!.to_i }
  .each { |line|
    last_price = line % 10
    price_pattern = []
    seen_patterns = Set.new
    2000.times.reduce(line) { |val, i|
      next_val = next_vals[val]
      price = next_val % 10
      price_pattern << price - last_price
      if i >= 3
        unless seen_patterns.include?(price_pattern)
          seen_patterns << price_pattern
          pattern_prices[price_pattern] += price
        end
        price_pattern = price_pattern[1..] # Dup the array to prevent hash key mutation
      end
      last_price = price
      next_val
    }
  }

sum = pattern_prices.values.max
pp "Sum? #{sum}"