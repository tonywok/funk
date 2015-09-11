require 'test_helper'
require 'funk/instruments/graph_viz'

describe Funk::Instruments::GraphViz do
  describe "#digraph" do
    it "builds the dependency graph" do
      graph = Funk.compile({
        a: -> (b, c) { b + c },
        b: -> (c) { c + 10 },
      }, instruments: [Funk::Instruments::GraphViz])
      result = graph.call(c: 2)

      graphviz = result.instruments["GraphViz"]
      graphviz.digraph.must_equal([
        "digraph {",
        "node c[label=< c <br/> 2 > shape=circle]",
        "node b[label=< b <br/> 12 > shape=box]",
        "c -> b",
        "node a[label=< a <br/> 14 > shape=box]",
        "b -> a",
        "c -> a",
        "}",
      ].join("\n"))
    end
  end
end
