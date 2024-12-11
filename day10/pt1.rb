require 'set'
@dirs = [
  [0, -1], # Up
  [1, 0], # Right
  [0, 1], # Down
  [-1, 0], # Left
]

trailheads = Set.new
@row_max = 0
@col_max = 0

@grid = File.readlines('input')
  .map(&:strip)
  .each_with_index.map { |line, ri|
    @col_max = line.length
    @row_max = ri
    line.split("").each_with_index.map { |ch, ci|
      trailheads << [ri, ci] if ch == "0"
      ch.to_i
    }
  }

@row_max += 1 # Consistency!

def traverse(y, x, height, path)
  coords = [y, x]

  # puts "Visiting #{[y, x]} from height #{height} and found #{next_height}"
  return 0 if path.include?(coords) || y < 0 || y >= @row_max || x < 0 || x >= @col_max

  next_height = @grid[y][x]
  return 0 if next_height - height != 1

  path << coords
  return 1 if next_height == 9

  score = @dirs.sum { |dy, dx|
    traverse(y + dy, x + dx, next_height, path)
  }
  path.delete(coords)
  score
end

sum = trailheads.sum { |y, x|
  path = Set.new
  traverse(y, x, -1, path)
}

pp "Sum? #{sum}"