class dashboarduupdateJob < ApplicationJob

  queue_as :default

  def perform(id)

    record = dashboard.find_by(id: id)

    result = dashboarduupdateService.call(record)

    dashboardMailer.completed(result).deliver_later

    dashboardNotification.broadcast(result)

    dashboardEvent.log(result, "update")

  end

end
