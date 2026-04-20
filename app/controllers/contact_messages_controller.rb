class ContactMessagesController < ApplicationController
  before_action :set_contact_message, only: %i[ show edit update destroy ]

  # GET /contact_messages or /contact_messages.json
  def index
    @contact_messages = ContactMessage.all
  end

  # GET /contact_messages/1 or /contact_messages/1.json
  def show
  end

  # GET /contact_messages/new
  def new
    @contact_message = ContactMessage.new
  end

  # GET /contact_messages/1/edit
  def edit
  end

  # POST /contact_messages or /contact_messages.json
  def create
    @message = ContactMessage.new(message_params)

    if @message.save
      respond_to do |format|
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend("toastContainer",
            partial: "shared/toast",
            locals:  { message: "Message received. We'll respond within 2–3 business days.", type: "success" })
        }
        format.html { redirect_to contact_path, notice: "Message sent!" }
      end
    else
      render :contact, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /contact_messages/1 or /contact_messages/1.json
  def update
    respond_to do |format|
      if @contact_message.update(contact_message_params)
        format.html { redirect_to @contact_message, notice: "Contact message was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @contact_message }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @contact_message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contact_messages/1 or /contact_messages/1.json
  def destroy
    @contact_message.destroy!

    respond_to do |format|
      format.html { redirect_to contact_messages_path, notice: "Contact message was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  def message_params
    params.require(:contact_message).permit(
      :name, :email, :organization, :inquiry_type, :message
    )
  end

    # Use callbacks to share common setup or constraints between actions.
    def set_contact_message
      @contact_message = ContactMessage.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def contact_message_params
      params.fetch(:contact_message, {})
    end
end
