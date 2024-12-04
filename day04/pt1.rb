require 'set'

grid = File.readlines('input')
  .map(&:strip)
  .map do |line|
    line.split("")
  end

ri_max = grid.size
ci_max = grid[0].size
mas = ["M", "A", "S"]
dirs = [
  [0, 1],
  [1, 0],
  [0, -1],
  [-1, 0],
  [1, 1],
  [1, -1],
  [-1, 1],
  [-1, -1],
]

sum = grid.each_with_index.sum { |row, ri|
  row.each_with_index.sum { |char, ci|
    next 0 unless char == "X"
    dirs.count { |dr, dc|
      cr = ri
      cc = ci
      word = (1..3).filter_map {
        cr += dr
        cc += dc
        next unless (cr >= 0) && (cr < ri_max) && (cc >= 0) && (cc < ci_max)
        grid[cr][cc]
      }
      puts "Word: #{word}"
      word == mas
    }
  }
}
pp "Sum? #{sum}"