require 'test_helper'

class GdsAuthsControllerTest < ActionController::TestCase
  setup do
    @gds_auth = gds_auths(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:gds_auths)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create gds_auth" do
    assert_difference('GdsAuth.count') do
      post :create, gds_auth: {  }
    end

    assert_redirected_to gds_auth_path(assigns(:gds_auth))
  end

  test "should show gds_auth" do
    get :show, id: @gds_auth
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @gds_auth
    assert_response :success
  end

  test "should update gds_auth" do
    put :update, id: @gds_auth, gds_auth: {  }
    assert_redirected_to gds_auth_path(assigns(:gds_auth))
  end

  test "should destroy gds_auth" do
    assert_difference('GdsAuth.count', -1) do
      delete :destroy, id: @gds_auth
    end

    assert_redirected_to gds_auths_path
  end
end
