require "test_helper"

class NewsletterSubscriptionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @newsletter_subscription = newsletter_subscriptions(:one)
  end

  test "should get index" do
    get newsletter_subscriptions_url
    assert_response :success
  end

  test "should get new" do
    get new_newsletter_subscription_url
    assert_response :success
  end

  test "should create newsletter_subscription" do
    assert_difference("NewsletterSubscription.count") do
      post newsletter_subscriptions_url, params: { newsletter_subscription: {} }
    end

    assert_redirected_to newsletter_subscription_url(NewsletterSubscription.last)
  end

  test "should show newsletter_subscription" do
    get newsletter_subscription_url(@newsletter_subscription)
    assert_response :success
  end

  test "should get edit" do
    get edit_newsletter_subscription_url(@newsletter_subscription)
    assert_response :success
  end

  test "should update newsletter_subscription" do
    patch newsletter_subscription_url(@newsletter_subscription), params: { newsletter_subscription: {} }
    assert_redirected_to newsletter_subscription_url(@newsletter_subscription)
  end

  test "should destroy newsletter_subscription" do
    assert_difference("NewsletterSubscription.count", -1) do
      delete newsletter_subscription_url(@newsletter_subscription)
    end

    assert_redirected_to newsletter_subscriptions_url
  end
end
