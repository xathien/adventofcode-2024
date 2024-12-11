require 'set'

antennae = Hash.new { |h, k| h[k] = [] }
row_max = 0
col_max = 0
File.readlines('input')
  .map(&:strip)
  .each_with_index { |line, ri|
    row_max = ri
    col_max = line.length
    line.split("").each_with_index { |ch, ci|
      next if ch == "."
      antennae[ch] << [ri, ci]
    }
  }

row_max += 1 # Consistency!

antinodes = Set.new
antennae.each { |_, coords|
  coords.combination(2).each { |(r1, c1), (r2, c2)|
    rx = r2 - r1
    cx = c2 - c1
    r3 = r2 + rx
    c3 = c2 + cx
    antinodes << [r3, c3] if r3 >= 0 && r3 < row_max && c3 >= 0 && c3 < col_max
    r3 = r1 - rx
    c3 = c1 - cx
    antinodes << [r3, c3] if r3 >= 0 && r3 < row_max && c3 >= 0 && c3 < col_max
  }
}

pp "Sum? #{antinodes.size}"