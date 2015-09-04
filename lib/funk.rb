require "funk/version"
require "funk/graph"
require "funk/evaluator"

module Funk

  def self.compile(fns: {}, strategy: Funk::Evaluators::Eager, instruments: [])
    graph = Graph.new(fns)
    strategy.new(graph, instruments: instruments)
  end

  def self.compile_module(mod, **args)
    dummy_receiver = Object.new
    fn_hash = mod.instance_methods(false).each_with_object({}) do |meth, hash|
      m = mod.instance_method(meth)
      hash[meth] = m.bind(dummy_receiver)
    end
    compile(fns: fn_hash, **args)
  end

end
