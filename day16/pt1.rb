require 'set'

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

def next_state(states_queue, f_score)
  states_queue.min_by { |node| f_score[node] } # Ewww, it's O(n) :(
end

def a_star(grid, ry, rx, ey, ex)
  path = {}

  # y, x, dir
  start_node = [ry, rx, :right]

  # Life would be better if this were a priority queue
  states_queue = Set.new([start_node])

  g_score = Hash.new(Float::INFINITY)
  g_score[start_node] = 0

  f_score = Hash.new(Float::INFINITY)
  f_score[start_node] = (ex - rx).abs + (ey - ry).abs


  until states_queue.empty?
    y, x, dir = current = next_state(states_queue, f_score)
    tile = grid[y][x]
    current_score = g_score[current]

    # puts "Checking #{y}, #{x}, #{dir} | #{tile} | #{current_score}"

    return current_score if tile == :end

    states_queue.delete(current)

    next if tile == :wall # We're not allowed to stand here

    # Try taking a step forward
    tentative_g_score = current_score + 1
    dy, dx = @dirs[dir]
    ny = y + dy
    nx = x + dx
    next_step = [ny, nx, dir]
    if tentative_g_score < g_score[next_step]
      path[next_step] = current
      g_score[next_step] = tentative_g_score
      f_score[next_step] = tentative_g_score + (ey - ny).abs + (ex - nx).abs
      states_queue << next_step
    end

    @rotations[dir].each { |next_dir|
      tentative_g_score = current_score + 1000
      rotate_state = [y, x, next_dir]
      next unless tentative_g_score < g_score[rotate_state]
      path[rotate_state] = current
      g_score[rotate_state] = tentative_g_score
      f_score[rotate_state] = tentative_g_score + (ey - y).abs + (ex - x).abs
      states_queue << rotate_state
    }
  end

  pp 'Uh... wtf'
end

score = a_star(grid, ry, rx, ey, ex)


pp "Sum? #{score}"