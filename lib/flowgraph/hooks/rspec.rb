# frozen_string_literal: true

module Flowgraph
  module Hooks
    module RSpec
      class << self
        def install_hook(recorder)
          hook_already_installed = !!@tracer
          @tracer = Tracer.new(recorder)
          return if hook_already_installed

          ::RSpec.configure do |config|
            config.around(:each, &method(:run_procsy))
          end
        end

        def run_procsy(procsy)
          method_name = procsy.example.full_description
          receiver = procsy.example
          defined_class = procsy.example.class
          source_location = procsy.example.location.split(":")

          @tracer.inject_event(RSpecExampleEvent.new(procsy.example, :call))
          @tracer.trace { procsy.run }
          @tracer.inject_event(RSpecExampleEvent.new(procsy.example, :return))
        end
      end
    end
  end
end
