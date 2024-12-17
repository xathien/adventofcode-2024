require 'fc'

@rotations = {
  :left => [:up, :down],
  :right => [:down, :up],
  :up => [:right, :left],
  :down => [:left, :right],
}
@dirs = {
  :left => [0, -1],
  :right => [0, 1],
  :up => [-1, 0],
  :down => [1, 0],
}

rx = 0
ry = 0
ey = 0
ex = 0

grid = File.readlines('input')
  .map(&:strip)
  .each_with_index.map { |line, ri|
    line.chars.each_with_index.map { |ch, ci|
      case ch
      when "#"
        :wall
      when "."
        :open
      when "E"
        ey = ri
        ex = ci
        :end
      when "S"
        ry = ri
        rx = ci
        :open
      end
    }
  }

def a_star(grid, ry, rx, ey, ex, best_score)
  path = Hash.new { |h, k| h[k] = [] }

  # y, x, dir
  start_node = [ry, rx, :right]

  states_queue = FastContainers::PriorityQueue.new(:min)
  states_queue.push(start_node, 0)

  g_score = Hash.new(Float::INFINITY)
  g_score[start_node] = 0

  f_score = Hash.new(Float::INFINITY)
  f_score[start_node] = (ex - rx).abs + (ey - ry).abs

  until states_queue.empty?
    y, x, dir = current = states_queue.pop
    tile = grid[y][x]
    current_score = g_score[current]

    # puts "Checking #{y}, #{x}, #{dir} | #{tile} | #{current_score}"

    if tile == :end
      return if current_score > best_score # We've exhausted the optimal routes
      path_queue = [current]
      visited = Set.new
      while (current = path_queue.pop)
        next if visited.include?(current)
        yield current
        visited << current
        path_queue.concat(path[current])
      end
      next
    end

    next if tile == :wall # We're not allowed to stand here

    # Try taking a step forward
    tentative_g_score = current_score + 1
    dy, dx = @dirs[dir]
    ny = y + dy
    nx = x + dx
    next_step = [ny, nx, dir]
    if tentative_g_score <= g_score[next_step]
      path[next_step] << current
      g_score[next_step] = tentative_g_score
      f_score[next_step] = tentative_g_score + (ey - ny).abs + (ex - nx).abs
      states_queue.push(next_step, tentative_g_score)
    end

    @rotations[dir].each { |next_dir|
      tentative_g_score = current_score + 1000
      rotate_state = [y, x, next_dir]
      next unless tentative_g_score <= g_score[rotate_state]
      path[rotate_state] << current
      g_score[rotate_state] = tentative_g_score
      f_score[rotate_state] = tentative_g_score + (ey - y).abs + (ex - x).abs
      states_queue.push(rotate_state, tentative_g_score)
    }
  end
end

# best_score = 7036
best_score = 104516
all_coords = Set.new
a_star(grid, ry, rx, ey, ex, best_score) { |y, x, _dir|
  all_coords << [y, x]
}


pp "Sum? #{all_coords.size}"