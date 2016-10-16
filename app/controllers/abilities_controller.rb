class AbilitiesController < ApplicationController

  respond_to :js, only: :create

  def index
    respond_with(@abilities = Ability.all)
  end

  def create
    respond_with(@ability = Ability.create(ability_params))
  end

  private

  def ability_params
    params.require(:ability).permit(:name)
  end

  def load_ability
    @ability = Ability.find(params[:id])
  end
end
