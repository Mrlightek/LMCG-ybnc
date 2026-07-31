class sessionMailer < ApplicationMailer

  def completed(result)

    @result = result

    mail(
      subject: "session completed"
    )

  end

end
