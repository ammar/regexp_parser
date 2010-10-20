require File.expand_path("../helpers", __FILE__)
%w{ lexer parser }.each do |subject|
  require File.expand_path("../#{subject}/test_all", __FILE__)
end
