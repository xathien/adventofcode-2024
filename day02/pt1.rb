require 'set'

sum = File.readlines('input')
  .map(&:strip)
  .count do |line|
    report = line.split(/\s+/).map(&:to_i)
    first, second = report[0..1]
    diff = second - first
    next false if diff.zero?
    ascending = diff.positive?
    report.each_cons(2).all? { |a, b|
      diff = b - a
      !diff.zero? && diff.positive? == ascending && diff.abs < 4
    }
  end

pp "Sum? #{sum}"