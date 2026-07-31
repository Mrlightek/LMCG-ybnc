class donationMailer < ApplicationMailer

  def completed(result)

    @result = result

    mail(
      subject: "donation completed"
    )

  end

end
