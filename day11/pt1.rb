require 'set'

stones = File.read('input').strip.split(" ").map(&:to_i)
25.times { |i|
  new_stones = []
  stones.each { |stone|
    if stone == 0
      new_stones << 1
    else
      digits = stone.digits.reverse
      digit_count = digits.size
      if digit_count.even?
        new_stones.push(digits[...digit_count / 2].join.to_i, digits[digit_count / 2...].join.to_i)
      else
        new_stones << stone * 2024
      end
    end
    stones = new_stones
  }
}

pp "Sum? #{stones.size}"