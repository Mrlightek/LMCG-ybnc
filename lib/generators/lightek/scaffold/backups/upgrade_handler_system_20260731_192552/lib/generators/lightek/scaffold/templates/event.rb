class <%= class_name %>Event


  def self.log(result, action)

    EventLog.create!(
      event_type: "#{action}_<%= file_name %>",
      data: result
    )

  end


end
