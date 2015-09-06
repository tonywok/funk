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
      result = Funk.compile(fns: {
        a: -> (b, c) { b + c },
        b: -> (c) { c + 10 },
      }).call(c: 2)

      result[:a].must_equal(14)
      result[:b].must_equal(12)
    end

    describe "missing dependencies" do

      it "self reference" do
        identity = { a: -> (a) { a } }
        policy = Funk.compile(fns: identity)
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
        policy = Funk.compile(fns: cycle)
        lambda { policy.call({}) }.must_raise(TSort::Cyclic)
      end
    end
  end
end
