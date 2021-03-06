# frozen_string_literal: true
require "flowgraph"
require "benchmark"

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

recorder = Flowgraph::Recorders::Sqlite.new("foo.sqlite3")

Flowgraph.record(recorder) do
  b = B.new
  def b.baz
  end

  b.bar
end

#puts
#Flowgraph.record(recorder) { C.new.bar }
