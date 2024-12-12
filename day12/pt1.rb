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

def traverse(coords, state, plot, coord_set)
  return if plot.include?(coords) # Already visited this one

  if !coord_set.include?(coords) # We're on another plot or outside the boundary
    state[:perimeter] += 1
    return
  end

  plot << coords
  state[:area] += 1

  y, x = coords
  @dirs.each { |dy, dx|
    traverse([y + dy, x + dx], state, plot, coord_set)
  }
end

plot = Set.new
sum = plots.values.sum { |coord_set|
  plot.clear
  coord_set.sum { |coords|
    next 0 if plot.include?(coords)
    state = { area: 0, perimeter: 0 }
    traverse(coords, state, plot, coord_set)
    state[:area] * state[:perimeter]
  }
}
pp "Sum? #{sum}"