require File.expand_path("../../helpers", __FILE__)

%w{
  base to_s to_h clone subexpression free_space tests
  traverse strfregexp
}.each do|tc|
  require File.expand_path("../test_#{tc}", __FILE__)
end

if RUBY_VERSION >= '2.0.0'
  require File.expand_path("../test_conditionals", __FILE__)
end
