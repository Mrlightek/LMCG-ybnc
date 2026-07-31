class dashboardMailer < ApplicationMailer

  def completed(result)

    @result = result

    mail(
      subject: "dashboard completed"
    )

  end

end
