module Funk
  module Instruments
    class GraphViz
      def initialize
        @dots = []
      end

      def after_call(fn, input, value)
        fn.dependencies.each do |dep|
          @dots << "#{dep} -> #{fn.name}"
        end
      end

      def digraph
        digraph = []
        digraph << "digraph {"
        digraph.concat(@dots)
        digraph << "}"
        digraph.join("\n")
      end

    end
  end
end
