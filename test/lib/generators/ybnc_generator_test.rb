require "test_helper"
require "generators/ybnc/ybnc_generator"

class YbncGeneratorTest < Rails::Generators::TestCase
  tests YbncGenerator
  destination Rails.root.join("tmp/generators")
  setup :prepare_destination

  # test "generator runs without errors" do
  #   assert_nothing_raised do
  #     run_generator ["arguments"]
  #   end
  # end
end
