class WordsController < ApplicationController

  def index
    render json: Word.order(word_index: :asc)
  end

end

