class ConceptsController < ApplicationController

  before_filter :authenticate_user!

  def index
    query = Concept.order(title: :asc, description: :asc).limit(10)
    if params[:q]
      # Nasty hack: strip periods in order to match DB records
      query_with_wildcards = "%#{params[:q].gsub(/\./, '')}%"
      query = query.where(
        'title ILIKE ? OR description ILIKE ?',
        query_with_wildcards,
        query_with_wildcards
      )
    end
    render json: query
  end

end

