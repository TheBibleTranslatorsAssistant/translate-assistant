class WordGroupsController < ApplicationController

  before_filter :authenticate_user!

  def index
    render json: WordGroup
      .order('(ending_word_id-starting_word_id) DESC', 'starting_word_id ASC')
  end

end

