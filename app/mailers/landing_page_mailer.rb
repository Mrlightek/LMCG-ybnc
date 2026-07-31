class landing_pageMailer < ApplicationMailer

  def completed(result)

    @result = result

    mail(
      subject: "landing_page completed"
    )

  end

end
