class newsletter_subscriptionMailer < ApplicationMailer

  def completed(result)

    @result = result

    mail(
      subject: "newsletter_subscription completed"
    )

  end

end
