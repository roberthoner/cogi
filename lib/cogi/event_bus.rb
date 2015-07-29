module Cogi
  class EventBus
    def initialize
    end

    def step
      queue = _queue.dup
      _queue.clear

      queue.each { |event_name, args|
        _process_event(event_name, args)
      }
    end

    def subscribe_to(event_name, &block)
      _subscriptions[event_name.to_sym] << block
    end

    def fire(event_name, *args)
      _queue << [event_name.to_sym, args]
    end

    private

    def _process_event(event_name, args)
      _subscriptions[event_name].each { |sub|
        sub.call(*args)
      }
    end

    def _subscriptions
      @__subscriptions ||= Hash.new([])
    end

    def _queue
      @__queue ||= []
    end
  end # EventBus
end # Cogi
