class VacanciesController < ApplicationController
  before_action :load_vacancy, only: [:show, :update, :edit]

  def index
    respond_with(@vacancies = Vacancy.all)
  end

  def new
    respond_with(@vacancy = Vacancy.new)
  end

  def create
    # pry
    respond_with(@vacancy = Vacancy.create(vacancy_params))
  end

  def show
    respond_with @vacancy
  end

  def update
    @vacancy.update(vacancy_params)
    respond_with(@vacancy)
  end

  def edit

  end

  private

  def vacancy_params
    params.require(:vacancy).permit(:name, :valid_till, :salary, :contacts, ability_ids: [])
  end

  def load_vacancy
    @vacancy = Vacancy.find(params[:id])
  end
end
