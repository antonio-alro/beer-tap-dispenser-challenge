require "test_helper"

class Api::V1::PingControllerTest < ActionDispatch::IntegrationTest
  test "#index method" do
    get api_v1_ping_index_path

    assert_response :success
  end
end
