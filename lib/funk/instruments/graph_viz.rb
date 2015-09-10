module Funk
  module Instruments
    class GraphViz
      def initialize
        @dots = []
      end

      def after_call(fn, input, value)
        name = "node #{fn.name}"
        style = {
          "label" => "< #{fn.name} <br/> #{value.inspect} >",
          "shape" => fn.is_a?(InputFn) ? "circle" : "box",
        }
        node = name + "[" + style.map { |attr,val| "#{attr}=#{val}" }.join(" ") + "]"

        @dots << node
        fn.dependencies.each do |dep|
          edge = "#{dep} -> #{fn.name}"
          @dots << edge
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
