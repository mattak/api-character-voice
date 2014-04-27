class ProgramStaffsController < ApplicationController
  before_action :set_program_staff, only: [:show, :edit, :update, :destroy]

  # GET /program_staffs
  # GET /program_staffs.json
  def index
    @program_staffs = ProgramStaff.all
  end

  # GET /program_staffs/1
  # GET /program_staffs/1.json
  def show
  end

  # GET /program_staffs/new
  def new
    @program_staff = ProgramStaff.new
  end

  # GET /program_staffs/1/edit
  def edit
  end

  # POST /program_staffs
  # POST /program_staffs.json
  def create
    @program_staff = ProgramStaff.new(program_staff_params)

    respond_to do |format|
      if @program_staff.save
        format.html { redirect_to @program_staff, notice: 'Program staff was successfully created.' }
        format.json { render :show, status: :created, location: @program_staff }
      else
        format.html { render :new }
        format.json { render json: @program_staff.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /program_staffs/1
  # PATCH/PUT /program_staffs/1.json
  def update
    respond_to do |format|
      if @program_staff.update(program_staff_params)
        format.html { redirect_to @program_staff, notice: 'Program staff was successfully updated.' }
        format.json { render :show, status: :ok, location: @program_staff }
      else
        format.html { render :edit }
        format.json { render json: @program_staff.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /program_staffs/1
  # DELETE /program_staffs/1.json
  def destroy
    @program_staff.destroy
    respond_to do |format|
      format.html { redirect_to program_staffs_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_program_staff
      @program_staff = ProgramStaff.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def program_staff_params
      params.require(:program_staff).permit(:staff_id, :program_id, :role)
    end
end
