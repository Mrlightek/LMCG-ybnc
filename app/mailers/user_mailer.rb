class userMailer < ApplicationMailer

  def completed(result)

    @result = result

    mail(
      subject: "user completed"
    )

  end

end
