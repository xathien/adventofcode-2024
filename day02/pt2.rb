require 'set'

sum = File.readlines('input')
  .map(&:strip)
  .count do |line|
    report = line.split(/\s+/).map(&:to_i)
    report.each_index.any? { |i|
      dampened_report = report[0...i] + report[i+1...report.length]
      ascending = nil
      dampened_report.each_cons(2).all? { |a, b|
        diff = b - a
        ascending = diff.positive? if ascending.nil?
        !diff.zero? && diff.positive? == ascending && diff.abs < 4
      }
    }
  end

pp "Sum? #{sum}"