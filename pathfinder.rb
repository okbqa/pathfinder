#!/usr/bin/env ruby
require 'sparql/client'

class PathFinder
  def initialize (endpoint)
    @sparql = SPARQL::Client.new(endpoint)
  end

  def shortestPath (u1, u2)
    # results = @endpoint.query(query)

    # results.each do |statement|
    #   puts statement.inspect
    # end

    r1 = RDF::URI.new(u1)
    r2 = RDF::URI.new(u2)
    query = @sparql.select(:p1).where([[r1, :p1, :t1], [:t1, :p2, r2]])
    # p query
    query.each_solution do |solution|
      puts solution.inspect
    end
  end
end

if __FILE__ == $0
  pf = PathFinder.new("http://dbpedia.org/sparql/")
  pf.shortestPath("http://dbpedia.org/resource/SAHSA", "http://dbpedia.org/resource/Honolulu_International_Airport")
end
