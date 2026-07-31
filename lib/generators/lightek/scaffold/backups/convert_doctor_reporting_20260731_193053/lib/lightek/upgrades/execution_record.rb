module Lightek
  module Upgrades

    ExecutionRecord =
      Struct.new(
        :name,
        :version,
        :status,
        :message,
        :executed_at,
        keyword_init: true
      )

  end
end
