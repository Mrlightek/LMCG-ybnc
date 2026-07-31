class landing_pageEvent

  def self.log(result, action)

    EventLog.create!(
      event_type: "\#{action}_landing_page",
      data: result
    )

  end

end
