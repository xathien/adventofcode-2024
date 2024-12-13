require 'set'

sum = File.readlines('input')
  .map(&:strip)
  .sum { |line|
    ax, ay, bx, by, tx, ty = line.split(" ").map(&:to_i)
    tx += 10000000000000
    ty += 10000000000000
    a = (ty*bx-by*tx)/(bx*ay-by*ax)
    b = (tx-ax*a)/bx
    next 0 if a < 0 || b < 0 || tx != ax*a+bx*b || ty != ay*a+by*b
    3*a+b
  }

pp "Sum? #{sum}"