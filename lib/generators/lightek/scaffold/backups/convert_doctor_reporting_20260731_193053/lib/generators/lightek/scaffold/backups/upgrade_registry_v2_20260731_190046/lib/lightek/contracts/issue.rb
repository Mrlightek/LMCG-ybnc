module Lightek
  module Contracts

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
