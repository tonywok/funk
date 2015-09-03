module Funk

  class CircularDependencyException < StandardError; end

  class Result
    def initialize(input)
      @input = input
      @result = {}
    end

    def call(fn)
      args = fn.dependencies
      fn.call(@result.merge(@input))
    end
  end

  module Evaluator

    class Eager
      attr_reader :graph, :instruments

      def initialize(graph, instruments: [])
        @graph = graph
        @instruments = instruments.map { |i| i.new }
      end

      def call(input)
        return_value = {}
        return_value[:input] = input
        return_value[:instruments] = @instruments
        return_value[:computed] = @graph.walk.inject({}) do |result, (name, fn)|
          result[name] = evaluate(fn, result.merge(input))
        end

        return_value
      end

      private

      def evaluate(fn, input)
        before_call(fn, input)
        value = fn.call(input)
        after_call(fn, input, value)
        value
      end

      def before_call(fn, input)
        instruments.each do |inst|
          inst.before_call(fn, input)
        end
      end

      def after_call(fn, input, value)
        instruments.reverse.each do |inst|
          inst.after_call(fn, input, value)
        end
      end

    end
  end
end
