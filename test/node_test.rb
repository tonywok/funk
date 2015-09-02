require 'test_helper'

class NodeTest < Minitest::Test

  def test_adding_edges
    node = Funk::Node.new("foo", -> {})
    edge = Funk::Node.new("bar", -> {})
    node.edges << edge

    assert node.edges.include?(edge)
  end

  def test_is_leaf
    node = Funk::Node.new("foo", -> {})
    edge = Funk::Node.new("bar", -> {})
    node.edges << edge

    assert !node.leaf?
    assert edge.leaf?
  end

end
