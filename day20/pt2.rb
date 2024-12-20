require 'fc'
require 'set'

@dirs = [
  [0, 1], # R
  [1, 0], # D
  [0, -1], # L
  [-1, 0], # U
]

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
      when "E"
        :end
      when "S"
        ry = ri
        rx = ci
        :open
      end
    }
  }

def dijkstra(grid, ry, rx)
  distances = Hash.new(Float::INFINITY)

  start_node = [ry, rx]
  queue = [start_node]
  distances[start_node] = 0

  while queue.any?
    next_queue = []
    queue.each { |node|
      y, x = node
      next_distance = distances[node] + 1
      @dirs.each { |dy, dx|
        ny = y + dy
        nx = x + dx
        tile = grid[ny][nx]
        next_step = [ny, nx]
        next if distances.key?(next_step) || tile == :wall
        distances[next_step] = next_distance
        next_queue << next_step
      }
    }
    queue = next_queue
  end
  distances
end

distances = dijkstra(grid, ry, rx)
base_time = distances[[ry, rx]]
# base_time = a_star(grid, ry, rx, ey, ex, Float::INFINITY)
puts "Base time: #{base_time}"
# minimum_saved = 50
minimum_saved = 100
puts "minimum_saved time: #{minimum_saved}"
cheat_dirs = (0..20).flat_map { |dy|
  (0..20-dy).flat_map { |dx|
    [[dy, dx], [dy, -dx], [-dy, dx], [-dy, -dx]]
  }
}.uniq!
route_count = distances.sum { |(y, x), steps_so_far|
  cheat_dirs.count { |dy, dx|
    neighbor = [dy + y, dx + x]
    neighbor_distance = distances[neighbor]
    next false if neighbor_distance.infinite?
    time_saved = (neighbor_distance - steps_so_far) - (dy.abs + dx.abs)
    time_saved >= minimum_saved
  }
}
# puts "By time: #{savings_by_time}"
# route_count = a_star(grid, ry, rx, ey, ex, base_time)
pp "Score? #{route_count}"
