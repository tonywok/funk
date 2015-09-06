require "funk/result"

module Funk
  module Evaluators
    class Eager
      attr_reader :graph

      def initialize(graph, instruments: [])
        @graph, @instruments = graph, instruments
      end

      def call(input)
        instruments = @instruments.map{ |i| i.new }
        @graph.tsort.each_with_object(Result.new(instruments)) do |fn, result|
          result[fn.name] = evaluate(fn, result.merge(input), instruments)
        end
      end

      private

      def evaluate(fn, input, instruments)
        before_call(fn, input, instruments)
        value = fn.call(input)
        after_call(fn, input, value, instruments)
        value
      end

      def before_call(fn, input, instruments)
        instruments.each do |inst|
          inst.before_call(fn, input)
        end
      end

      def after_call(fn, input, value, instruments)
        instruments.reverse.each do |inst|
          inst.after_call(fn, input, value)
        end
      end

    end
  end
end
