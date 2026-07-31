class skillMailer < ApplicationMailer

  def completed(result)

    @result = result

    mail(
      subject: "skill completed"
    )

  end

end
