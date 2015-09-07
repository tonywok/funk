require 'test_helper'

describe Funk do

  module Example
    def holdback(draw0, amount)
      amount - draw0
    end

    def holdback_max(is_rehab)
      is_rehab ? 15000 : 0
    end

    def sub_holdback(holdback, holdback_max)
      holdback < 0 || holdback > holdback_max ? 500 : 0
    end
  end

  describe "compile_function" do

    it "works" do
      policy = Funk.compile_module(Example)
      result = policy.call({
        is_rehab: true,
        draw0: 90_000,
        amount: 110_000,
      })

      result[:holdback_max].must_equal(15_000)
      result[:sub_holdback].must_equal(500)
      result[:holdback].must_equal(20_000)
    end
  end

  describe "compile" do

    it "works" do
      result = Funk.compile(
        a: -> (b, c) { b + c },
        b: -> (c) { c + 10 }
      ).call(c: 2)

      result[:a].must_equal(14)
      result[:b].must_equal(12)
    end

    describe "missing dependencies" do

      it "self reference" do
        identity = { a: -> (a) { a } }
        policy = Funk.compile(identity)
        err = lambda { policy.call({}) }.must_raise(Funk::MissingDepenciesException)
        err.message.must_match "Fn a is missing dependencies [:a]"
      end
    end

    describe "cycles" do

      it "catches circular dependencies" do
        cycle = {
          a: -> (b) { b },
          b: -> (a) { a },
        }
        policy = Funk.compile(cycle)
        lambda { policy.call({}) }.must_raise(TSort::Cyclic)
      end
    end
  end

  describe "various graph scenarios" do

    it "calculates statistics" do
      stats = Funk.compile(
        count: -> (items) { items.length },
        mean:  -> (items, count) { (items.reduce(:+) / count).round(1) },
        mean_sq: -> (items, count) { (items.reduce(1) { |m, i| m + i**2 } / count).round(1) },
        variance: -> (mean, mean_sq) { (mean_sq - mean**2).round(1) }
      )
      stats.call(items: [1.0,1,2,3,5,8,13]).must_equal(
        items: [1,1,2,3,5,8,13],
        count: 7,
        mean:  4.7,
        mean_sq: 39.1,
        variance: 17.0
      )
    end

    it "calculates a big, rather unordered tree" do
      stats = Funk.compile(
        a: -> (z, y) { z + y },
        b: -> (a, y) { a + y },
        c: -> (x, w) { x + w },
        d: -> (a, c) { a + c },
        e: -> (f, g) { f + g },
        f: -> (w, x) { w + x },
        g: -> (c, d) { c + d }
      )

      stats.call(w:1, x:2, y:3, z:4).must_equal(
        a: 7,
        b: 10,
        c: 3,
        d: 10,
        e: 16,
        f: 3,
        g: 13,
        w: 1,
        x: 2,
        y: 3,
        z: 4
      )
    end
  end
end
