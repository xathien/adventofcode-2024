require 'set'

orders = Hash.new { |h, k| h[k] = [] }
File.readlines('input')
  .map(&:strip)
  .each do |line|
    before, after = line.split("|")
    orders[before] << after
  end
sum = File.readlines('input2')
  .map(&:strip)
  .sum do |line|
    arr = line.split(",")
    valid = arr.each_with_index.all? { |pg, i|
      afters = orders[pg]
      next true unless afters.any?
      (0...i).none? { |j|
        afters.include?(arr[j])
      }
    }
    next 0 unless valid
    arr[(arr.size-1)/2].to_i
  end

pp "Sum? #{sum}"