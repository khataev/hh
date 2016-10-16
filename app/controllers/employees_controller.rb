class EmployeesController < ApplicationController
  before_action :load_employee, only: [:show, :update, :edit, :vacancies]

  def index
    respond_with(@employees = Employee.all)
  end

  def new
    respond_with(@employee = Employee.new)
  end

  def create
    # pry
    respond_with(@employee = Employee.create(employee_params))
  end

  def show
    respond_with @employee
  end

  def update
    @employee.update(employee_params)
    respond_with(@employee)
  end

  def vacancies
    respond_with(@employee)
  end

  private

  def employee_params
    params.require(:employee).permit(:name, :search_status, :salary, :contacts, ability_ids: [])
  end

  def load_employee
    @employee = Employee.find(params[:id])
  end
end
