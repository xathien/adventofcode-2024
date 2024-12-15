require 'set'

dirs = {
  "^" => [0, -1, 0, 1], # Up
  ">" => [1, 0, -1, 0], # Right
  "v" => [0, 1, 0, -1], # Down
  "<" => [-1, 0, 1, 0], # Left
}

rx = 0
ry = 0

grid = File.readlines('input')
  .map(&:strip)
  .each_with_index.map { |line, ri|
    line.chars.each_with_index.flat_map { |ch, ci|
      case ch
      when "#"
        [:wall, :wall]
      when "."
        [:open, :open]
      when "O"
        [:box_left, :box_right]
      when "@"
        ry = ri
        rx = ci * 2
        [:robot, :open]
      end
    }
  }

def can_move(grid, x, y, dy)
  y += dy
  target = grid[y][x]
  return true if target == :open
  return false if target == :wall
  if target == :box_left
    can_move(grid, x, y, dy) && can_move(grid, x+1, y, dy)
  else # box_right
    can_move(grid, x-1, y, dy) && can_move(grid, x, y, dy)
  end
end

def move(grid, x, y, dy)
  ny = y + dy
  target = grid[ny][x]
  if target == :box_left
    move(grid, x, ny, dy)
    move(grid, x+1, ny, dy)
  elsif target == :box_right
    move(grid, x-1, ny, dy)
    move(grid, x, ny, dy)
  end
  grid[ny][x] = grid[y][x]
  grid[y][x] = :open
end

movements = File.readlines("input2").map(&:strip!).join
movements.chars.each { |dir|
  dx, dy, bdx, bdy = dirs[dir]
  nx = rx + dx
  ny = ry + dy
  target = grid[ny][nx]
  if dir == "<" || dir == ">" # Nothing has changed for l/r
    # Find the end of our push path
    until target == :open || target == :wall
      nx += dx
      ny += dy
      target = grid[ny][nx]
    end
    if target == :open # We can move, pushing boxen
      while nx != rx || ny != ry
        px = nx + bdx
        py = ny + bdy
        grid[ny][nx] = grid[py][px]
        nx = px
        ny = py
      end
      grid[ny][nx] = :open
      rx += dx
      ry += dy
    end
  else
    if can_move(grid, rx, ry, dy)
      move(grid, rx, ry, dy)
      rx += dx
      ry += dy
    end
  end
}

# Let's render the warehouse and count coords
sum = grid.each_with_index.sum { |row, ri|
  row_sum = row.each_with_index.sum { |ch, ci|
    case ch
    when :wall
      print "#"
      0
    when :open
      print "."
      0
    when :box_left
      print "["
      ri * 100 + ci
    when :box_right
      print "]"
      0
    when :robot
      print "@"
      0
    end
  }
  puts
  row_sum
}

pp "Sum? #{sum}"