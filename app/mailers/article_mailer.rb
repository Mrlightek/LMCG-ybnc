class articleMailer < ApplicationMailer

  def completed(result)

    @result = result

    mail(
      subject: "article completed"
    )

  end

end
