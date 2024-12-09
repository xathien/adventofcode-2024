require 'set'

fs = []
File.read('input').strip.split("").each_slice(2).each_with_index { |(file_c, free_c), id|
  fs += ([id] * file_c.to_i) + ([nil] * free_c.to_i)
}
fs.reverse!
idx = 0
while idx < fs.size
  id = fs[idx]
  end_idx = idx+1
  if id
    # See how large this block is
    end_idx = idx + 1
    end_idx += 1 while end_idx < fs.size && fs[end_idx] == id
    count = end_idx - idx

    # Find a suitable place to live
    j = fs.size - 1
    nil_end_idx = end_idx - 1
    nil_count = -1
    while j >= end_idx
      if fs[j] == nil
        nil_end_idx = j - 1
        nil_end_idx -= 1 while nil_end_idx >= end_idx - 1 && fs[nil_end_idx] == nil
        nil_count = j - nil_end_idx
        break if nil_count >= count
      end
      j -= 1
    end
    if nil_count >= count
      count.times {
        fs[j] = id
        fs[idx] = nil
        idx += 1
        j -= 1
      }
    end
  end
  idx = end_idx
end
fs.reverse!
puts "Done shuffling"
sum = fs.each_with_index.sum { |id, i|
  next 0 unless id
  id * i
}

pp "Sum? #{sum}"