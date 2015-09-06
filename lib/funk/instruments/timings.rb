module Funk
  module Instruments
    class Timings
      def initialize()
        @timings = {}
      end

      def before_call(fn, input)
        @timings[fn.name] = {:start => Time.now}
      end

      def after_call(fn, input, value)
        @timings[fn.name][:end] = Time.now
      end

      def each
        @timings.sort {|a,b|
          a[1][:start] <=> b[1][:start]
        }.each do |t|
          yield t[0], t[1]
        end
      end
    end
  end
end
