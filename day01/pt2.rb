require 'set'

a = []
b = Hash.new(0)
sum = File.readlines('input')
    .map(&:strip)
    .each do |line|
      first, second = line.split(/\s+/)
      a << first.to_i
      b[second.to_i] += 1
    end

sum = a.sum { |first| first * b[first] }
pp "Sum? #{sum}"