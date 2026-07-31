class initiativeMailer < ApplicationMailer

  def completed(result)

    @result = result

    mail(
      subject: "initiative completed"
    )

  end

end
