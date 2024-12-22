require 'matrix'

@button_positions = {
  "7" => Vector[0, 0],
  "8" => Vector[0, 1],
  "9" => Vector[0, 2],
  "4" => Vector[1, 0],
  "5" => Vector[1, 1],
  "6" => Vector[1, 2],
  "1" => Vector[2, 0],
  "2" => Vector[2, 1],
  "3" => Vector[2, 2],
  "0" => Vector[3, 1],
  "A" => Vector[3, 2],
  "^" => Vector[0, 1],
  "B" => Vector[0, 2],
  "<" => Vector[1, 0],
  "v" => Vector[1, 1],
  ">" => Vector[1, 2],
}
@A = @button_positions["A"]
@B = @button_positions["B"]
@bad_numpad = Vector[3, 0]
@bad_arrows = Vector[0, 0]

@dirs = {
  "^" => Vector[-1, 0],
  "v" => Vector[1, 0],
  "<" => Vector[0, -1],
  ">" => Vector[0, 1],
}

def to_moveset(sv, ev, bad=Vector[0, 0])
  dy, dx = (ev - sv).to_a
  button_str = dy.negative? ? "^" * dy.abs : "v" * dy
  button_str += dx.negative? ? "<" * dx.abs : ">" * dx
  [button_str, button_str.reverse].uniq.filter { |dirs|
    dirs.chars.map { |dir| @dirs[dir] }
      .reduce([sv]) { |acc, dirv|
        acc + [acc.last + dirv]
      }.none? { |posv| posv == bad }
    }.map { |dirs| dirs + "B" }
end

@path_cache = {}
def shortest_path(sub_code, depth = 0, max_depth = 25)
  cache_key = [sub_code, depth]
  return @path_cache[cache_key] if @path_cache.key?(cache_key)

  bad = depth == 0 ? @bad_numpad : @bad_arrows
  curv = depth == 0 ? @A : @B
  length = 0
  sub_code.chars.each { |char|
    targetv = @button_positions[char]
    possibilities = to_moveset(curv, targetv, bad)
    if depth == max_depth
      length += possibilities[0].length
    else
      length += possibilities.map { |poss|
        shortest_path(poss, depth + 1, max_depth)
      }.min
    end
    curv = targetv
  }
  @path_cache[cache_key] = length
end

complexity = File.readlines('input')
  .map(&:strip)
  .sum { |code|
    length = shortest_path(code + "A")
    puts "Complexity for #{code} * #{length} == #{code.to_i * length}"
    code.to_i * length
  }

pp "Score? #{complexity}"