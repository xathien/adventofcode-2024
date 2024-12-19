require 'fc'
require 'set'

@dirs = [
  [0, 1], # R
  [1, 0], # D
  [0, -1], # L
  [-1, 0], # U
]

# max_idx = 6
max_idx = 70

# take_count = 12
take_count = 1024

corrupted = File.readlines('input')
  .take(take_count)
  .map(&:strip)
  .map { |line|
    line.split(",").map(&:to_i)
  }
  .to_set

def a_star(corrupted, max_idx)
  path = Hash.new { |h, k| h[k] = [] }

  # y, x
  start_node = [0, 0]

  states_queue = FastContainers::PriorityQueue.new(:min)
  states_queue.push(start_node, 0)

  g_score = Hash.new(Float::INFINITY)
  g_score[start_node] = 0

  f_score = Hash.new(Float::INFINITY)
  f_score[start_node] = max_idx * 2

  until states_queue.empty?
    y, x = current = states_queue.pop
    next if corrupted.include?(current) || y < 0 || y > max_idx || x < 0 || x > max_idx

    current_score = g_score[current]

    # puts "Checking #{y}, #{x}, | #{tile} | #{current_score}"

    return current_score if x == max_idx && y == max_idx

    tentative_g_score = current_score + 1
    @dirs.each { |dy, dx|
      ny = y + dy
      nx = x + dx
      next_step = [ny, nx]
      next unless tentative_g_score < g_score[next_step]

      path[next_step] << current
      g_score[next_step] = tentative_g_score
      f_score[next_step] = tentative_g_score + max_idx * 2 - nx - ny
      states_queue.push(next_step, tentative_g_score)
    }
  end
end

score = a_star(corrupted, max_idx)

pp "Score? #{score}"