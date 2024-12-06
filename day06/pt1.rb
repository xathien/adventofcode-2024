require 'set'

dirs = [
  [0, -1], # Up
  [1, 0], # Right
  [0, 1], # Down
  [-1, 0], # Left
]
dir = 0

visited = Set.new
walls = Set.new
row = 0
col = 0
row_max = 0
col_max = 0

File.readlines('input')
  .map(&:strip)
  .each_with_index do |line, ri|
    col_max = line.length
    row_max = ri
    line.split("")
      .each_with_index { |ch, ci|
        if ch == "#"
          walls << [ci, ri]
        elsif ch == "^"
          row = ri
          col = ci
        end
      }
  end

row_max += 1 # Consistency!
while row >= 0 && row < row_max && col >= 0 && col < col_max
  visited << [col, row]
  dx, dy = dirs[dir]
  ncol = col + dx
  nrow = row + dy
  if walls.include?([ncol, nrow])
    dir = (dir + 1) % 4 # Rotate right
  else
    col = ncol
    row = nrow
  end
end

pp "Sum? #{visited.size}"