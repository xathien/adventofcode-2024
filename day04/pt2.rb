require 'set'

grid = File.readlines('input')
  .map(&:strip)
  .map do |line|
    line.split("")
  end

ri_max = grid.size
ci_max = grid[0].size
dirs = [
  [-1, -1], # UL
  [-1, 1], # UR
  [1, -1], # DL
  [1, 1], # DR
]
mases = Set.new([
  ["M", "S", "M", "S"],
  ["M", "M", "S", "S"],
  ["S", "S", "M", "M"],
  ["S", "M", "S", "M"],
])

sum = grid.each_with_index.sum { |row, ri|
  row.each_with_index.count { |char, ci|
    next false unless char == "A"
    # puts "A at #{[ri, ci]}"
    result = mases.include?(dirs.filter_map { |dr, dc|
      cr = ri + dr
      cc = ci + dc
      next unless cr >= 0 && cr < ri_max && cc >= 0 && cc < ci_max
      # puts "Char at #{[cr, cc]} == #{grid[cr][cc]}"
      grid[cr][cc]
    })
    # puts "Result? #{result}"
    # puts "Coords: #{[ri, ci]}" if result
    result
  }
}
pp "Sum? #{sum}"