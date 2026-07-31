class volunteer_applicationMailer < ApplicationMailer

  def completed(result)

    @result = result

    mail(
      subject: "volunteer_application completed"
    )

  end

end
