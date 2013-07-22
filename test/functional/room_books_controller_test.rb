require 'test_helper'

class RoomBooksControllerTest < ActionController::TestCase
  setup do
    @room_book = room_books(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:room_books)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create room_book" do
    assert_difference('RoomBook.count') do
      post :create, room_book: {  }
    end

    assert_redirected_to room_book_path(assigns(:room_book))
  end

  test "should show room_book" do
    get :show, id: @room_book
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @room_book
    assert_response :success
  end

  test "should update room_book" do
    put :update, id: @room_book, room_book: {  }
    assert_redirected_to room_book_path(assigns(:room_book))
  end

  test "should destroy room_book" do
    assert_difference('RoomBook.count', -1) do
      delete :destroy, id: @room_book
    end

    assert_redirected_to room_books_path
  end
end
