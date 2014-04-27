require 'test_helper'

class ProgramStaffsControllerTest < ActionController::TestCase
  setup do
    @program_staff = program_staffs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:program_staffs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create program_staff" do
    assert_difference('ProgramStaff.count') do
      post :create, program_staff: { program_id: @program_staff.program_id, role: @program_staff.role, staff_id: @program_staff.staff_id }
    end

    assert_redirected_to program_staff_path(assigns(:program_staff))
  end

  test "should show program_staff" do
    get :show, id: @program_staff
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @program_staff
    assert_response :success
  end

  test "should update program_staff" do
    patch :update, id: @program_staff, program_staff: { program_id: @program_staff.program_id, role: @program_staff.role, staff_id: @program_staff.staff_id }
    assert_redirected_to program_staff_path(assigns(:program_staff))
  end

  test "should destroy program_staff" do
    assert_difference('ProgramStaff.count', -1) do
      delete :destroy, id: @program_staff
    end

    assert_redirected_to program_staffs_path
  end
end
