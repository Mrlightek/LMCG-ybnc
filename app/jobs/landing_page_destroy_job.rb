class landing_pageudestroyJob < ApplicationJob

  queue_as :default

  def perform(id)

    record = landing_page.find_by(id: id)

    result = landing_pageudestroyService.call(record)

    landing_pageMailer.completed(result).deliver_later

    landing_pageNotification.broadcast(result)

    landing_pageEvent.log(result, "destroy")

  end

end
