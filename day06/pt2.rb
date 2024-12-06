require 'set'

dirs = [
  [0, -1], # Up
  [1, 0], # Right
  [0, 1], # Down
  [-1, 0], # Left
]

walls = Set.new
init_row = 0
init_col = 0
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
          init_row = ri
          init_col = ci
        end
      }
  end

row_max += 1 # Consistency!

visited = Set.new
row = init_row
col = init_col
dir = 0
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

states = Set.new
loop_count = visited.count { |new_wall|
  # puts "Checking #{new_wall}"
  walls << new_wall
  states.clear
  row = init_row
  col = init_col
  dir = 0
  loop_detected = while row >= 0 && row < row_max && col >= 0 && col < col_max
    break true if states.include?([col, row, dir])
    states << [col, row, dir]
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

  # (0...row_max).each { |ri|
  #   (0...col_max).each { |ci|
  #     ch = "."
  #     if [ci, ri] == new_wall
  #       ch = "O"
  #     elsif visited.include?([ci, ri])
  #       ch = "X"
  #     elsif walls.include?([ci, ri])
  #       ch = "#"
  #     end
  #     print ch
  #   }
  #   puts
  # }
  # puts "Looped? #{loop_detected}"

  walls.delete(new_wall)
  loop_detected || false
}


pp "Sum? #{loop_count}"