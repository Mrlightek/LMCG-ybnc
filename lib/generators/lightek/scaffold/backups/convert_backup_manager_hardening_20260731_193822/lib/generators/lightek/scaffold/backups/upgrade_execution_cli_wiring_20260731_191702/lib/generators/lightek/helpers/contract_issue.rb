module Lightek
  module Generators
    module Helpers

      ContractIssue =
        Struct.new(
          :analyzer,
          :level,
          :message,
          :file,
          :line,
          keyword_init: true
        )

    end
  end
end
