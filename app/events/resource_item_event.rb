class resource_itemEvent

  def self.log(result, action)

    EventLog.create!(
      event_type: "\#{action}_resource_item",
      data: result
    )

  end

end
