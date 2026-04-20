class NewsletterSubscriptionsController < ApplicationController
  before_action :set_newsletter_subscription, only: %i[ show edit update destroy ]

  # GET /newsletter_subscriptions or /newsletter_subscriptions.json
  def index
    @newsletter_subscriptions = NewsletterSubscription.all
  end

  # GET /newsletter_subscriptions/1 or /newsletter_subscriptions/1.json
  def show
  end

  # GET /newsletter_subscriptions/new
  def new
    @newsletter_subscription = NewsletterSubscription.new
  end

  # GET /newsletter_subscriptions/1/edit
  def edit
  end

  # POST /newsletter_subscriptions or /newsletter_subscriptions.json
  def create
    @sub = NewsletterSubscription.new(sub_params)

    if @sub.save
      respond_to do |format|
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.replace("newsletter_form",
              partial: "newsletter_subscriptions/success",
              locals:  { name: @sub.first_name }),
            turbo_stream.prepend("toastContainer",
              partial: "shared/toast",
              locals:  { message: "✓ Welcome to YBNC! See you on the frontlines.", type: "success" })
          ]
        }
        format.html { redirect_to root_path, notice: "Welcome to YBNC!" }
      end
    else
      respond_to do |format|
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace("newsletter_form",
            partial: "newsletter_subscriptions/form",
            locals:  { sub: @sub })
        }
        format.html { redirect_to root_path, alert: @sub.errors.full_messages.to_sentence }
      end
    end
  end

  # PATCH/PUT /newsletter_subscriptions/1 or /newsletter_subscriptions/1.json
  def update
    respond_to do |format|
      if @newsletter_subscription.update(newsletter_subscription_params)
        format.html { redirect_to @newsletter_subscription, notice: "Newsletter subscription was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @newsletter_subscription }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @newsletter_subscription.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /newsletter_subscriptions/1 or /newsletter_subscriptions/1.json
  def destroy
    @newsletter_subscription.destroy!

    respond_to do |format|
      format.html { redirect_to newsletter_subscriptions_path, notice: "Newsletter subscription was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  def sub_params
    params.require(:newsletter_subscription)
          .permit(:email, :first_name, :source)
  end

    # Use callbacks to share common setup or constraints between actions.
    def set_newsletter_subscription
      @newsletter_subscription = NewsletterSubscription.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def newsletter_subscription_params
      params.fetch(:newsletter_subscription, {})
    end
end
