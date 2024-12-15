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
    line.chars.each_with_index.map { |ch, ci|
      case ch
      when "#"
        :wall
      when "."
        :open
      when "O"
        :box
      when "@"
        ry = ri
        rx = ci
        :robot
      end
    }
  }

movements = File.readlines("input2").map(&:strip!).join
movements.chars.each { |dir|
  dx, dy, bdx, bdy = dirs[dir]
  tx = nx = rx + dx
  ty = ny = ry + dy
  target = grid[ny][nx]
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
    rx = tx
    ry = ty
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
    when :box
      print "O"
      ri * 100 + ci
    when :robot
      print "@"
      0
    end
  }
  puts
  row_sum
}

pp "Sum? #{sum}"