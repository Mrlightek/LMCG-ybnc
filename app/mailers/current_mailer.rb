class currentMailer < ApplicationMailer

  def completed(result)

    @result = result

    mail(
      subject: "current completed"
    )

  end

end
