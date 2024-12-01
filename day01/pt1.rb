require 'set'

a = []
b = []
sum = File.readlines('input')
    .map(&:strip)
    .each do |line|
      first, second = line.split(/\s+/)
      a << first.to_i
      b << second.to_i
    end

a.sort!
b.sort!
sum = a.zip(b).sum { |first, second| (first - second).abs }
pp "Sum? #{sum}"