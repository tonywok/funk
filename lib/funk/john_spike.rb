module Graph
  module Helpers
    private def assert_dependencies_present_in(hash)
      present_keys = Set.new(hash.keys)
      unless dependencies.subset?(present_keys)
        raise "Missing dependencies #{dependencies.difference(present_keys).to_a}"
      end
    end
  end

  class Fn
    include Helpers

    attr_reader :dependencies

    def self.from_method(m)
      self.new(&m)
    end

    def initialize(&block)
      @dependencies = Set.new(block.parameters.map(&:last))
      @fn = block
    end

    def call(hash)
      assert_dependencies_present_in(hash)
      args = hash.values_at(*dependencies)
      @fn.call(*args)
    end
  end

  class Evaluator
    include Helpers

    attr_reader :dependencies
    attr_reader :hash_of_graph_fns
    attr_reader :fn_execution_order

    def initialize(hash_of_graph_fns)
      @hash_of_graph_fns = hash_of_graph_fns

      child_deps = hash_of_graph_fns.map { |_, fn| fn.dependencies }.reduce(:+)
      @dependencies = child_deps - hash_of_graph_fns.keys

      calculate_dependency_graph
    end

    def call(input_hash)
      assert_dependencies_present_in(input_hash)
      fn_execution_order.each_with_object({}) do |key, result|
        fn = hash_of_graph_fns[key]
        result[key] = fn.call(input_hash.merge(result))
      end
    end

    private

    def calculate_dependency_graph
      # magic
      computations = hash_of_graph_fns.keys
      deps = {}
      hash_of_graph_fns.each do |comp_name, fn|
        deps[comp_name] = fn.dependencies.select { |d| computations.include?(d) }
      end

      @fn_execution_order = []

      until deps.empty?
        met = deps.detect do |comp_name, ds|
          ds.empty? || ds.all? { |d| @fn_execution_order.include?(d) }
        end

        unless met
          raise "unable to satisfy dependencies. met: #{@fn_execution_order}, unmet: #{deps.keys}"
        end

        next_comp = met[0]
        @fn_execution_order << next_comp
        deps.delete(next_comp)
      end

    end
  end

  module Example
    def holdback(draw0, amount)
      amount - draw0
    end

    def holdback_max(is_rehab)
      if is_rehab
        15000
      else
        0
      end
    end

    def sub_holdback(holdback, holdback_max)
      if holdback < 0 || holdback > holdback_max
        500
      else
        0
      end
    end
  end

  def self.compile(hash_of_graph_fns)
    Evaluator.new(hash_of_graph_fns)
  end

  def self.compile_module(mod)
    dummy_receiver = Object.new
    fn_hash = mod.instance_methods(false).each_with_object({}) do |meth, hash|
      m = mod.instance_method(meth)
      hash[meth] = Graph::Fn.from_method(m.bind(dummy_receiver))
    end

    compile(fn_hash)
  end

  def self.test
    policy = Graph.compile_module(Example)
    policy.call(
      is_rehab: true,
      draw0: 90_000,
      amount: 110_000
    )
  end
end
