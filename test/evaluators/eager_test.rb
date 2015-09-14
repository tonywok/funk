require "test_helper"

describe Funk::Evaluators::Eager do
  describe ".call" do
    def evaluator
      fns = {
        a: -> (x, y=0) { x + y },
        b: -> (a) { a**2 },
      }
      Funk.compile(fns, strategy: Funk::Evaluators::Eager)
    end

    describe "when all arguments are provided" do
      it "calculates successfully" do
        evaluator.call(x:2, y:4).must_equal(a:6, b:36, x:2, y:4)
      end
    end

    describe "when required arguments are missing" do
      it "raises an error" do
        err = -> { evaluator.call(y:4) }.must_raise(Funk::MissingDependenciesException)
        err.message.must_match("Function :a is missing dependencies [:x]")
      end
    end

    describe "when optional arguments are omitted" do
      it "does not raise an error" do
        result = evaluator.call(x:2)
        result[:a].must_equal(2)
        result[:b].must_equal(4)
      end
    end
  end

  describe ".expected_input" do
    it "tells you what input variables are expected to evaluate" do
      fns = {
        a: -> (x) { x },
        b: -> (y) { a },
      }
      evaluator = Funk.compile(fns)
      evaluator.expected_input_keys.must_equal(["x", "y"])
    end
  end

  describe ".slice" do
    it "compiles an evaluator for a subgraph using the provided nodes and their dependencies" do
      evaluator = Funk.compile({
        a: -> (x) { x*x },
        b: -> (y) { y*y },
        c: -> (b, y) { b*y },
      })
      evaluator.required_input.sort.must_equal(["x", "y"])

      sliced_evaluator = evaluator.slice(:b, :c)
      sliced_evaluator.required_input.sort.must_equal(["y"])
      sliced_evaluator.call(y: 5).must_equal(b: 25, c: 125)
    end
  end
end
