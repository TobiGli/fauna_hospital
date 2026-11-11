class SpeciesController < ApplicationController
  def index
    @species = Species.all
  end

  def new
    @species = Species.new
  end

  def create
    @species = Species.new(species_params)

    if @species.save
      redirect_to @species, notice: "Species was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def species_params
    params.require(:species).permit(
      :common_name,
      :scientific_name,
      :taxonomy_class,
      :conservation_status
    )
  end
end
