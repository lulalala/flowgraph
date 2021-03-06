# frozen_string_literal: true
require "benchmark"
require "flowgraph"
require "flowgraph/hooks/minitest"
require "minitest/autorun"

class A
  def initialize
  end

  def foo
  end

  def bar
    foo
  end
end

class B < A
  def foo
    Benchmark.realtime { baz }
  end
end

class C < A
  def foo
    super
  end

  def bar
    foo
    super
    self.class.baz
  end

  class << self
    def baz
    end
  end
end

class Test < Minitest::Test
  def setup
    @b = B.new
    def @b.baz
    end
  end

  def test_b
    @b.bar
  end
end

recorder = Flowgraph::Recorders::Sqlite.new("foo.sqlite3")
Flowgraph::Hooks::Minitest.install_hook(recorder)
