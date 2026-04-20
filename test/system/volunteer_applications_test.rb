require "application_system_test_case"

class VolunteerApplicationsTest < ApplicationSystemTestCase
  setup do
    @volunteer_application = volunteer_applications(:one)
  end

  test "visiting the index" do
    visit volunteer_applications_url
    assert_selector "h1", text: "Volunteer applications"
  end

  test "should create volunteer application" do
    visit volunteer_applications_url
    click_on "New volunteer application"

    click_on "Create Volunteer application"

    assert_text "Volunteer application was successfully created"
    click_on "Back"
  end

  test "should update Volunteer application" do
    visit volunteer_application_url(@volunteer_application)
    click_on "Edit this volunteer application", match: :first

    click_on "Update Volunteer application"

    assert_text "Volunteer application was successfully updated"
    click_on "Back"
  end

  test "should destroy Volunteer application" do
    visit volunteer_application_url(@volunteer_application)
    click_on "Destroy this volunteer application", match: :first

    assert_text "Volunteer application was successfully destroyed"
  end
end
