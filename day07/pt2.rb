require 'set'

def try_operands(total, index, operands, target)
  return false if total > target
  return total == target if index == operands.size

  next_operand = operands[index]
  [:+, :*, :concat].any? { |operator|
    new_total = if operator == :concat
      (total.to_s + next_operand.to_s).to_i
    else
      total.send(operator, next_operand)
    end
    try_operands(new_total, index + 1, operands, target)
  }
end

sum = File.readlines('input')
  .map(&:strip)
  .sum do |line, ri|
    operands = line.split(" ").map(&:to_i)
    target = operands.shift
    try_operands(0, 0, operands, target) ? target : 0
  end

pp "Sum? #{sum}"