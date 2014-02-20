#!/usr/bin/env ruby
require 'sparql/client'

class PathFinder
  def initialize (endpoint)
    @sparql = SPARQL::Client.new(endpoint)
    @p_variable = "p0"
    @t_variable = "t0"
  end

  def shortestPath (u1, u2, max_hop = 2)
    ti = RDF::URI.new(u1) # initial term
    tf = RDF::URI.new(u2) # final term

    (1 .. max_hop).each do |h|
      puts "== #{h}-hop path =="

      # variables for predicates
      p_variables = []
      (1 .. h).each {|i| p_variables << ('p' + i.to_s).to_sym}

      # variables for terms
      t_variables = [ti]
      (1 ... h).each {|i| t_variables << ('t' + i.to_s).to_sym}
      t_variables << tf

      # triples
      triples = []
      (1 .. h).each do |i|
        triples << [t_variables[i - 1], p_variables[i - 1], t_variables[i]]
      end

      # variations
      var = [triples]

      (0 ... triples.length).each do |i| # for i'th triple in a triples
        new_var = []                     # generate new variations
        var.each do |triples|              # for each triples in current variations
          new_triples = triples.dup
          new_triples[i] = triples[i].reverse
          new_var << new_triples
        end

        var += new_var
      end

      var.each do |v|
        query = @sparql.select(*p_variables).where(*v).limit(10)
        p query
        puts "[paths]---"
        query.each_solution do |solution|
          puts solution.inspect
        end

        puts "==========\n"
        sleep(1)
      end
    end

    return
 

    query = @sparql.select(:p1, :p2).where(*bgps).limit(10)
    # p query
    query.each_solution do |solution|
      puts solution.inspect
    end
  end

end

if __FILE__ == $0
  pf = PathFinder.new("http://dbpedia.org/sparql")
  pf.shortestPath("http://dbpedia.org/resource/SAHSA", "http://dbpedia.org/resource/Honolulu_International_Airport")
end
