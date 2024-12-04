require 'set'

act = true
sum = File.readlines('input')
  .map(&:strip)
  .sum do |line|
    line.scan(/mul\((\d{1,3}),(\d{1,3})\)|(don't|do)|/).sum { |a, b, toggle|
      if toggle
        puts toggle
        act = (toggle == "do")
        next 0
      end
      next 0 unless act
      a.to_i * b.to_i
    }
  end

pp "Sum? #{sum}"