require File.expand_path("../helpers", __FILE__)
%w{
  anchors comments escapes groups lexer parser properties
  quantifiers sets
}.each do|tc|
  require File.expand_path("../test_#{tc}", __FILE__)
end
