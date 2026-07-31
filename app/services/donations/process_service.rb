module Donations
  class ProcessService
    def initialize(donation)
      @donation = donation
    end

    def call
      process_payment
      send_notifications

      @donation
    end

    private

    attr_reader :donation

    def process_payment
      PaymentService.call(
        type: :donation,
        payment_method: donation.method,
        amount: donation.amount,
        user: donation.user
      )
    end

    def send_notifications
      Notifications::DonationCreated.call(donation)
    end
  end
end