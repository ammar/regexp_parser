# frozen_string_literal: true

# Defines works_on_ractor helper for testing Ractor compatibility.
# Returns true if the code was run on a Ractor, false otherwise.
# Re-raises any exceptions encountered within the Ractor.
if defined?(Ractor.shareable_proc)
  def works_on_ractor(*args, &callback)
    callback = Ractor.shareable_proc(&callback)
    result   = Ractor.new(callback, *args) do |callback, *args|
      begin
        callback.call(*args)
        nil
      rescue => e
        Ractor.make_shareable([e.class, e.message, e.backtrace].freeze)
      end
    end.value
    raise(*result) if result
    true
  end
else
  def works_on_ractor(*args)
    yield(*args)
    false
  end
end
