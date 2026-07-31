class contact_messageMailer < ApplicationMailer

  def completed(result)

    @result = result

    mail(
      subject: "contact_message completed"
    )

  end

end
