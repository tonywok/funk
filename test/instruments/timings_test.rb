require 'test_helper'
require 'funk/instruments/timings'

describe Funk::Instruments::Timings do
  it "profiles the execution of each computation" do
    graph = Funk.compile({
      a: -> (b, c) { b + c },
      b: -> (c) { c + 10 },
    }, instruments: [Funk::Instruments::Timings])
    result = graph.call(c: 2)

    timings = result.instruments.first
    timings.each do |name, timing|
      assert [:a, :b, :c].include?(name)
      assert_kind_of Time, timing[:start]
      assert_kind_of Time, timing[:end]
    end
  end
end
