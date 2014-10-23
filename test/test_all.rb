require File.expand_path("../helpers", __FILE__)

%w{ scanner syntax token lexer parser expression }.each do |subject|
  require File.expand_path("../#{subject}/test_all", __FILE__)
end
