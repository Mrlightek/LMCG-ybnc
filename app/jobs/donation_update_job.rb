class donationuupdateJob < ApplicationJob

  queue_as :default

  def perform(id)

    record = donation.find_by(id: id)

    result = donationuupdateService.call(record)

    donationMailer.completed(result).deliver_later

    donationNotification.broadcast(result)

    donationEvent.log(result, "update")

  end

end
