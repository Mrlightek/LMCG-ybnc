module Lightek
  module Upgrades

    Result =
      Struct.new(
        :name,
        :version,
        :status,
        :message,
        keyword_init: true
      )

  end
end
