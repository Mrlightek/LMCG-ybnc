class <%= class_name %>Mailer < ApplicationMailer


  def completed(result)

    @result = result

    mail(
      subject: "<%= class_name %> process completed"
    )

  end


end
