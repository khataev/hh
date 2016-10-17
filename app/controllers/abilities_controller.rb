class AbilitiesController < ApplicationController

  before_action :load_object, only: :create

  respond_to :js, only: :create

  def index
    respond_with(@abilities = Ability.all)
  end

  def create
    respond_with(@ability = Ability.create(ability_params), @object)
  end

  private

  def ability_params
    params.require(:ability).permit(:name)
  end

  def load_ability
    @ability = Ability.find(params[:id])
  end

  def load_object
    object_name = params[:ability][:object_name]
    object_id = params[:ability][:object_id]
    if object_name
      @object = object_id.empty? ? object_name.constantize.new : object_name.constantize.find(object_id)
    end
  end
end
