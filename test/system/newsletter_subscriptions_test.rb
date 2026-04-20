require "application_system_test_case"

class NewsletterSubscriptionsTest < ApplicationSystemTestCase
  setup do
    @newsletter_subscription = newsletter_subscriptions(:one)
  end

  test "visiting the index" do
    visit newsletter_subscriptions_url
    assert_selector "h1", text: "Newsletter subscriptions"
  end

  test "should create newsletter subscription" do
    visit newsletter_subscriptions_url
    click_on "New newsletter subscription"

    click_on "Create Newsletter subscription"

    assert_text "Newsletter subscription was successfully created"
    click_on "Back"
  end

  test "should update Newsletter subscription" do
    visit newsletter_subscription_url(@newsletter_subscription)
    click_on "Edit this newsletter subscription", match: :first

    click_on "Update Newsletter subscription"

    assert_text "Newsletter subscription was successfully updated"
    click_on "Back"
  end

  test "should destroy Newsletter subscription" do
    visit newsletter_subscription_url(@newsletter_subscription)
    click_on "Destroy this newsletter subscription", match: :first

    assert_text "Newsletter subscription was successfully destroyed"
  end
end
