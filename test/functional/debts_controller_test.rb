require 'test_helper'

class DebtsControllerTest < ActionController::TestCase
  setup do
    @debt = debts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:debts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create debt" do
    assert_difference('Debt.count') do
      post :create, debt: { body: @debt.body, date: @debt.date, title: @debt.title, value: @debt.value }
    end

    assert_redirected_to debt_path(assigns(:debt))
  end

  test "should show debt" do
    get :show, id: @debt
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @debt
    assert_response :success
  end

  test "should update debt" do
    put :update, id: @debt, debt: { body: @debt.body, date: @debt.date, title: @debt.title, value: @debt.value }
    assert_redirected_to debt_path(assigns(:debt))
  end

  test "should destroy debt" do
    assert_difference('Debt.count', -1) do
      delete :destroy, id: @debt
    end

    assert_redirected_to debts_path
  end
end
