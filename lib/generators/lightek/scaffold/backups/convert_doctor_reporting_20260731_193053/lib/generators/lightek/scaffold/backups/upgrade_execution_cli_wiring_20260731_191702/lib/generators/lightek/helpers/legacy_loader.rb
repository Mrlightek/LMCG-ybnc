require "lightek"

module Lightek
  module Generators
    module Helpers

      ContractValidator =
        ::Lightek::Contracts::Validator unless const_defined?(:ContractValidator)

    end
  end
end
