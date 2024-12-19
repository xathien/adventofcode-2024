require 'fc'
require 'set'

patterns = File.readlines('input')
  .map(&:strip)

reg = /^(#{patterns.shift})+$/
score = patterns.count { |pattern| reg.match?(pattern) }
pp "Score? #{score}"