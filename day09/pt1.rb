require 'set'

fs = []
File.read('input').strip.split("").each_slice(2).each_with_index { |(file_c, free_c), id|
  fs += ([id] * file_c.to_i) + ([nil] * free_c.to_i)
}
j = fs.size - 1
sum = fs.each_with_index.sum { |id, i|
  next 0 if i > j
  while id.nil?
    id = fs[j]
    j -= 1
  end
  next 0 if i > j
  id * i
}

pp "Sum? #{sum}"