require 'fc'
require 'set'

patterns = File.readlines('input')
  .map(&:strip)

count_cache = Hash.new(0)
count_cache[""] = 1
towels = patterns.shift.split("|")
def match_count(pattern, towels, count_cache)
  return count_cache[pattern] if count_cache.key?(pattern)
  count_cache[pattern] = towels.sum { |towel|
   next 0 unless pattern.start_with?(towel)
   match_count(pattern[towel.size..], towels, count_cache)
  }
end

score = patterns.sum { |pattern| match_count(pattern, towels, count_cache) }
pp "Score? #{score}"