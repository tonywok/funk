require "funk/result"

module Funk
  module Evaluators
    class Eager
      attr_reader :graph, :instruments

      def initialize(graph, instruments: [])
        @graph, @instruments = graph, instruments
      end

      def call(input)
        @graph.tsort.each_with_object(Result.new(@instruments.map{ |i| i.new })) do |fn, result|
          result[fn.name] = evaluate(fn, result.merge(input))
        end
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
