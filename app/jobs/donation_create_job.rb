class donationucreateJob < ApplicationJob

  queue_as :default

  def perform(id)

    record = donation.find_by(id: id)

    result = donationucreateService.call(record)

    donationMailer.completed(result).deliver_later

    donationNotification.broadcast(result)

    donationEvent.log(result, "create")

  end

end
