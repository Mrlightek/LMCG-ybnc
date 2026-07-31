class resource_itemMailer < ApplicationMailer

  def completed(result)

    @result = result

    mail(
      subject: "resource_item completed"
    )

  end

end
