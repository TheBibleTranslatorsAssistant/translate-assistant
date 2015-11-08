class ConceptsController < ApplicationController

  before_filter :authenticate_user!

  def index
    if params[:q]
      query = Concept.search(params[:q])
    else
      query = Concept.order(title: :asc, description: :asc).limit(10)
    end
    render json: query
  end

end

