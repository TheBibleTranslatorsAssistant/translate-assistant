class ConceptsController < ApplicationController

  def index
    query = Concept.order(title: :asc, description: :asc).limit(10)
    if params[:q]
      query_with_wildcards = "#{params[:q]}%"
      query = query.where(
        'title ILIKE ? OR description ILIKE ?',
        query_with_wildcards,
        query_with_wildcards
      )
    end
    render json: query
  end

end
