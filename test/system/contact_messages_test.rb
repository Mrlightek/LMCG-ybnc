require "application_system_test_case"

class ContactMessagesTest < ApplicationSystemTestCase
  setup do
    @contact_message = contact_messages(:one)
  end

  test "visiting the index" do
    visit contact_messages_url
    assert_selector "h1", text: "Contact messages"
  end

  test "should create contact message" do
    visit contact_messages_url
    click_on "New contact message"

    click_on "Create Contact message"

    assert_text "Contact message was successfully created"
    click_on "Back"
  end

  test "should update Contact message" do
    visit contact_message_url(@contact_message)
    click_on "Edit this contact message", match: :first

    click_on "Update Contact message"

    assert_text "Contact message was successfully updated"
    click_on "Back"
  end

  test "should destroy Contact message" do
    visit contact_message_url(@contact_message)
    click_on "Destroy this contact message", match: :first

    assert_text "Contact message was successfully destroyed"
  end
end
