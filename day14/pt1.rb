require 'set'

# max_x = 11
# max_y = 7
max_x = 101
max_y = 103
x_half = max_x / 2
y_half = max_y / 2

quadrants = [0, 0, 0, 0]
File.readlines('input')
  .map(&:strip)
  .each { |line|
    x, y, dx, dy = line.split(",").map(&:to_i)
    quadrant_index = 0
    xf = (x + (100*dx)) % max_x
    yf = (y + (100*dy)) % max_y
    next if xf == x_half || yf == y_half
    quadrant_index += 1 if xf > x_half
    quadrant_index += 2 if yf > y_half
    quadrants[quadrant_index] += 1
    puts "Final position #{xf}, #{yf}"
  }

pp "Sum? #{quadrants.reduce(&:*)}"