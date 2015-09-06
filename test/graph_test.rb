require 'test_helper'

describe Funk::Graph do
  it "orders functions in dependency order" do
    graph = Funk::Graph.new(
      a: -> (b, d) { "#{b}, #{d}" },
      b: -> (c, e) { "#{c}, #{e}" },
      c: -> (d, e, f) { "#{d}, #{e}, #{f}" },
      g: -> (f) { "separate graph" },
    )

    seen = []

    graph.tsort.each do |fn|
      assert !seen.include?(fn.name)
      seen += fn.dependencies
    end
  end
end
