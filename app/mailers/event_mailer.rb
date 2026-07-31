class eventMailer < ApplicationMailer

  def completed(result)

    @result = result

    mail(
      subject: "event completed"
    )

  end

end
