require 'fc'
require 'set'

links = Hash.new { |h, k| h[k] = Set.new }

File.readlines('input')
  .map(&:strip)
  .each { |line|
    first, second = line.split("-")
    links[first] << second
    links[second] << first
  }

@largest_clique = []
def bron(current_clique, candidates, excluded, links)
  if candidates.empty? && excluded.empty?
    @largest_clique = current_clique if current_clique.size > @largest_clique.size
    return
  end

  candidates.each { |candidate|
    candidate_links = links[candidate]
    bron(current_clique | [candidate], candidates & candidate_links, excluded & candidate_links, links)
    candidates.delete(candidate)
    excluded << candidate
  }
end

bron(Set.new, links.keys.to_set, Set.new, links)

pp "Code? #{@largest_clique.to_a.sort!.join(",")}"