require 'fc'
require 'set'

# From => To
@arrow_paths = {
  A: {
    A: [[:A]],
    U: [[:L, :A]],
    R: [[:D, :A]],
    D: [[:D, :L, :A], [:L, :D, :A]],
    L: [[:D, :L, :L, :A]], # DLDA? Can't imagine that's ever the best
  },
  U: {
    A: [[:R, :A]],
    U: [[:A]],
    R: [[:R, :D, :A], [:D, :R, :A]],
    D: [[:D, :A]],
    L: [[:D, :L, :A]],
  },
  R: {
    A: [[:U, :A]],
    U: [[:L, :U, :A], [:U, :L, :A]],
    R: [[:A]],
    D: [[:L, :A]],
    L: [[:L, :L, :A]],
  },
  D: {
    A: [[:U, :R, :A], [:R, :U, :A]],
    U: [[:U, :A]],
    R: [[:R, :A]],
    D: [[:A]],
    L: [[:L, :A]],
  },
  L: {
    A: [[:R, :R, :U, :A]], # RURA? Same deal
    U: [[:R, :U, :A]],
    R: [[:R, :R, :A]],
    D: [[:R, :A]],
    L: [[:A]],
  },
}
numpad_paths = {
  0 => {
    2 => [[:U]],
    A: [[:R]]
  },
  1 => {
    4 => [[:U]],
    7 => [[:U, :U]]
  },
  2 => {
    9 => [[:U, :U, :R], [:R, :U, :U]],
    A: [[:R, :D], [:D, :R]],
  },
  3 => {
    7 => [[:U, :U, :L, :L], [:L, :L, :U, :U]],
    8 => [[:U, :U, :L], [:L, :U, :U]],
    A: [[:D]],
  },
  4 => {
    3 => [[:R, :R, :D], [:D, :R, :R]],
    5 => [[:R]],
    8 => [[:R, :U], [:U, :R]],
    A: [[:R, :R, :D, :D]],
  },
  5 => {
    6 => [[:R]],
  },
  6 => {
    A: [[:D, :D]],
  },
  7 => {
    4 => [[:D]],
    9 => [[:R, :R]],
  },
  8 => {
    0 => [[:D, :D, :D]],
    2 => [[:D, :D]],
    3 => [[:D, :D, :R], [:R, :D, :D]],
  },
  9 => {
    7 => [[:L, :L]],
    8 => [[:L]],
    A: [[:D, :D, :D]]
  },
  A: {
    0 => [[:L]],
    1 => [[:U, :L, :L]],
    3 => [[:U]],
    4 => [[:U, :U, :L, :L]],
    9 => [[:U, :U, :U]],
  }
}

@path_cache = {}
def shortest_path(s_key, e_key, depth, max_depth = 2)
  # Human can push whatever keys they like
  paths = @arrow_paths[s_key][e_key]
  return paths.first if depth == max_depth
  cache_key = [s_key, e_key, depth]
  return @path_cache[cache_key] if @path_cache.key?(cache_key)

  @path_cache[cache_key] = paths.map { |buttons|
    ([:A] + buttons).each_cons(2).flat_map { |ns_key, ne_key|
      shortest_path(ns_key, ne_key, depth + 1, max_depth)
    }
  }.min_by(&:length)
  @path_cache[cache_key]
end

complexity = File.readlines('input')
  .map(&:strip)
  .map { |line| line.chars.map(&:to_i) }
  .sum { |code|
    # Find the shortest path of button presses
    path = []
    code = [:A] + code + [:A]
    code.each_cons(2) { |s_key, e_key|
      best_path = numpad_paths[s_key][e_key].map { |buttons|
        ([:A] + buttons + [:A]).each_cons(2).flat_map { |s_button, e_button|
          shortest_path(s_button, e_button, 1)
        }
      }.min_by(&:length)
      path.push(*best_path)
    }

    code[1..3].join.to_i * path.size
  }

pp "Score? #{complexity}"