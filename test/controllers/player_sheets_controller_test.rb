require 'test_helper'

class PlayerSheetsControllerTest < ActionController::TestCase
  setup do
    @player_sheet = player_sheets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:player_sheets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create player_sheet" do
    assert_difference('PlayerSheet.count') do
      post :create, player_sheet: {  }
    end

    assert_redirected_to player_sheet_path(assigns(:player_sheet))
  end

  test "should show player_sheet" do
    get :show, id: @player_sheet
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @player_sheet
    assert_response :success
  end

  test "should update player_sheet" do
    patch :update, id: @player_sheet, player_sheet: {  }
    assert_redirected_to player_sheet_path(assigns(:player_sheet))
  end

  test "should destroy player_sheet" do
    assert_difference('PlayerSheet.count', -1) do
      delete :destroy, id: @player_sheet
    end

    assert_redirected_to player_sheets_path
  end
end
