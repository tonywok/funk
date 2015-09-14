require "tsort"
require "funk/fn"
require "funk/input_fn"

module Funk
  class Graph

    def initialize(map)
      fn_map = map.each_with_object({}) do |(name, impl), fn_map|
        fn = fn_map[name] = Fn.new(name, impl)
        fn.dependencies.each do |dep_name|
          fn_map[dep_name] ||= InputFn.new(dep_name)
        end
      end
      accum = Hash.new { |h,k| h[k] = [] }
      @nodes = fn_map.each_with_object(accum) do |(name, fn), graph|
        graph[fn] = []
        fn.dependencies.each do |dep_name|
          graph[fn] << fn_map[dep_name]
        end
      end
    end

    # Topological Sort - exposes tsort enum
    #
    include TSort

    def tsort_each_child(n, &b)
      @nodes[n].each(&b)
    end

    def tsort_each_node(&b)
      @nodes.each_key(&b)
    end

    def input
      @nodes.select {|fn| fn.is_a?(InputFn) }.map(&:name)
    end
  end
end
