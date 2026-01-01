require "test_helper"

class LandingPagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @landing_page = landing_pages(:one)
  end

  test "should get index" do
    get landing_pages_url
    assert_response :success
  end

  test "should get new" do
    get new_landing_page_url
    assert_response :success
  end

  test "should create landing_page" do
    assert_difference("LandingPage.count") do
      post landing_pages_url, params: { landing_page: { copywriting: @landing_page.copywriting, services_id: @landing_page.services_id, styles: @landing_page.styles, title: @landing_page.title } }
    end

    assert_redirected_to landing_page_url(LandingPage.last)
  end

  test "should show landing_page" do
    get landing_page_url(@landing_page)
    assert_response :success
  end

  test "should get edit" do
    get edit_landing_page_url(@landing_page)
    assert_response :success
  end

  test "should update landing_page" do
    patch landing_page_url(@landing_page), params: { landing_page: { copywriting: @landing_page.copywriting, services_id: @landing_page.services_id, styles: @landing_page.styles, title: @landing_page.title } }
    assert_redirected_to landing_page_url(@landing_page)
  end

  test "should destroy landing_page" do
    assert_difference("LandingPage.count", -1) do
      delete landing_page_url(@landing_page)
    end

    assert_redirected_to landing_pages_url
  end
end
