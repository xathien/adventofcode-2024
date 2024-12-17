require 'set'

target = [2,4,1,1,7,5,4,4,1,4,0,3,5,5,3,0]
valid_as = [0]
target.each_index { |idx|
  expected_output = target[-(idx+1)..]
  valid_as = valid_as.flat_map { |last_a|
    last_a <<= 3
    (0...8).filter_map { |nibble|
      a = last_a + nibble
      b = 0
      c = 0
      out = []
      until a.zero?
        b = a[0..2]
        b ^= 1
        c = a / (2 ** b)
        b ^= c ^ 4
        a >>= 3
        out << b % 8
      end
      next unless out == expected_output
      last_a + nibble
    }
  }
}

pp "Output? #{valid_as.min}"