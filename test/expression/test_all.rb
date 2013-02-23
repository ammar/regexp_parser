require File.expand_path("../../helpers", __FILE__)

%w{
  base to_s clone
}.each do|tc|
  require File.expand_path("../test_#{tc}", __FILE__)
end
