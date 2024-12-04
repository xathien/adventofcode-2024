require 'set'

sum = File.readlines('input')
  .map(&:strip)
  .sum do |line|
    line.scan(/mul\((\d{1,3}),(\d{1,3})\)/).sum { |a, b| a.to_i * b.to_i }
  end

pp "Sum? #{sum}"