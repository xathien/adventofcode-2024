require 'set'

stones = Hash.new(0)
File.read('input').strip.split(" ").each { |stone| stones[stone.to_i] += 1 }

75.times { |i|
  new_stones = Hash.new(0)
  stones.each { |stone, count|
    if stone == 0
      new_stones[1] += count
    else
      digits = stone.digits.reverse
      digit_count = digits.size
      if digit_count.even?
        new_stone = digits[...digit_count / 2].join.to_i
        new_stones[new_stone] += count
        new_stone = digits[digit_count / 2...].join.to_i
        new_stones[new_stone] += count
      else
        new_stones[stone * 2024] += count
      end
    end
    stones = new_stones
  }
}

pp "Sum? #{stones.values.sum}"