require "test_helper"

class VolunteerApplicationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @volunteer_application = volunteer_applications(:one)
  end

  test "should get index" do
    get volunteer_applications_url
    assert_response :success
  end

  test "should get new" do
    get new_volunteer_application_url
    assert_response :success
  end

  test "should create volunteer_application" do
    assert_difference("VolunteerApplication.count") do
      post volunteer_applications_url, params: { volunteer_application: {} }
    end

    assert_redirected_to volunteer_application_url(VolunteerApplication.last)
  end

  test "should show volunteer_application" do
    get volunteer_application_url(@volunteer_application)
    assert_response :success
  end

  test "should get edit" do
    get edit_volunteer_application_url(@volunteer_application)
    assert_response :success
  end

  test "should update volunteer_application" do
    patch volunteer_application_url(@volunteer_application), params: { volunteer_application: {} }
    assert_redirected_to volunteer_application_url(@volunteer_application)
  end

  test "should destroy volunteer_application" do
    assert_difference("VolunteerApplication.count", -1) do
      delete volunteer_application_url(@volunteer_application)
    end

    assert_redirected_to volunteer_applications_url
  end
end
