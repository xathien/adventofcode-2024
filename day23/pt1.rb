require 'fc'
require 'set'

links = Hash.new { |h, k| h[k] = Set.new }
t_names = Set.new

File.readlines('input')
  .map(&:strip)
  .each { |line|
    first, second = line.split("-")
    links[first] << second
    links[second] << first
    t_names << first if first.start_with?("t")
    t_names << second if second.start_with?("t")
  }

triads = Set.new
t_names.each { |t_name|
  t_links = links[t_name]
  t_links.each { |other|
    other_links = links[other]
    intersection = t_links & other_links
    intersection.each { |third| triads << Set.new([t_name, other, third])}
  }
}

pp "Sum? #{triads.count}"