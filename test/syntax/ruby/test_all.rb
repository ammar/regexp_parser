require File.expand_path("../../../helpers", __FILE__)

%w{files 1.8 1.9.1 1.9.3 2.0.0 2.2.0}.each do|tc|
  require File.expand_path("../test_#{tc}", __FILE__)
end
