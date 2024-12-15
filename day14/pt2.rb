require 'set'

# max_x = 11
# max_y = 7
max_x = 101
max_y = 103

robots = File.readlines('input')
  .map(&:strip)
  .map { |line|
    line.split(",").map(&:to_i)
  }

seconds = 0
current_coords = Hash.new(0)
loop do
  seconds += 1
  current_coords.clear
  robots.each_with_index { |(x, y, dx, dy), i|
    robots[i][0] = x = (x + dx) % max_x
    robots[i][1] = y = (y + dy) % max_y
    current_coords[[x, y]] += 1
  }
  picture = (16..46).all? { |x| current_coords.key?([x, 22]) }
  if picture
    puts "--------------------------"
    puts "Seconds elapsed #{seconds}"
    puts "Overlapping bots: #{picture}"
    (0...max_y).each { |y|
      (0...max_x).each { |x|
        count = current_coords[[x, y]]
        print (count > 0 ? count : ".")
      }
      puts
    }
    gets
  end
end
pp "Sum? #{quadrants.reduce(&:*)}"