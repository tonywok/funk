module Funk
  class Node

    class MissingDependency < StandardError; end

    attr_reader :name, :fnk, :edges

    def initialize(name, fnk)
      @name = name
      @fnk = fnk
      @edges = []
    end

    def evaluate(results)
      if fnk.nil?
        results[name]
      else
        fnk.parameters.each do |arg_type, param|
          results.fetch(param) do
            if [:keyreq, :req].include?(arg_type)
              raise MissingDependency, "function #{name} is missing required argument: #{param}"
            end
          end
        end
      end
    end

    def leaf?
      edges.empty?
    end

    def to_s
      if leaf?
        name.inspect
      else
        "#{name.inspect} -> (#{edges.map{ |e| e.to_s }.join(', ')})"
      end
    end
  end
end
