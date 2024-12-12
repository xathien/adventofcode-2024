require 'set'

@dirs = [
  [0, -1], # Up
  [1, 0], # Right
  [0, 1], # Down
  [-1, 0], # Left
]

plots = Hash.new { |h, k| h[k] = Set.new }
File.readlines('input')
  .map(&:strip)
  .each_with_index.map { |line, ri|
    line.split("").each_with_index.map { |ch, ci|
      plots[ch] << [ri, ci]
    }
  }

def traverse(coords, dy, dx, plot, edges, coord_set)
  return 0 if plot.include?(coords) # Already visited this one

  y, x = coords
  if !coord_set.include?(coords) # We're on another plot or outside the boundary
    edges << [y, x, dy, dx]
    return 0
  end

  plot << coords

  1 + @dirs.sum { |dy, dx|
    traverse([y + dy, x + dx], dy, dx, plot, edges, coord_set)
  }
end

def traverse_edges(edge, edges, visited_edges)
  return false if visited_edges.include?(edge) || !edges.include?(edge)

  visited_edges << edge
  y, x, dy0, dx0 = edge
  @dirs.each { |dy, dx|
    traverse_edges([y + dy, x + dx, dy0, dx0], edges, visited_edges)
  }
  true
end

plot = Set.new
edges = Set.new
visited_edges = Set.new
sum = plots.values.sum { |coord_set|
  plot.clear
  coord_set.sum { |coords|
    next 0 if plot.include?(coords)
    edges.clear
    area = traverse(coords, nil, nil, plot, edges, coord_set)
    visited_edges.clear
    edge_count = edges.count { |edge|
      traverse_edges(edge, edges, visited_edges)
    }
    area * edge_count
  }
}

pp "Sum? #{sum}"