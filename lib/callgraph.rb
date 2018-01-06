# frozen_string_literal: true

require "callgraph/event_defaults"
require "callgraph/hooks"
require "callgraph/recorder"
require "callgraph/recorders/filtered"
require "callgraph/recorders/sqlite"
require "callgraph/recorders/stream"
require "callgraph/rspec_example_event"
require "callgraph/tracepoint_event"
require "callgraph/tracer"
require "callgraph/version"

module Callgraph
  class << self
    def record(recorder)
      Callgraph::Tracer.new(recorder).trace { yield }
    end
  end
end
