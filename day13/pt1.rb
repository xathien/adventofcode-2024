require 'set'

sum = File.readlines('input')
  .map(&:strip)
  .sum { |line|
    ax, ay, bx, by, tx, ty = line.split(" ").map(&:to_i)
    min_cost = Float::INFINITY
    (1..100).each { |a_times|
      a_cost = 3 * a_times
      x = ax * a_times
      y = ay * a_times
      break if x > tx || y > ty || a_cost > min_cost
      (1..100).each { |b_times|
        cost = a_cost + b_times
        x += bx
        y += by
        break if x > tx || y > ty || cost >= min_cost
        if x == tx && y == ty
          min_cost = cost
          break
        end
      }
    }
    min_cost == Float::INFINITY ? 0 : min_cost
  }

pp "Sum? #{sum}"