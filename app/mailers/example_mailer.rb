class ExampleMailer < ApplicationMailer

  def completed(result)
    @result = result

    mail(
      subject: "Process completed"
    )
  end

end
