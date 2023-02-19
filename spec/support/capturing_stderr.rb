require 'stringio'

def capturing_stderr
  old_stderr, $stderr = $stderr, StringIO.new
  yield
  $stderr.string
ensure
  $stderr = old_stderr
end
