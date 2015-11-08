class WordsController < ApplicationController

  before_filter :authenticate_user!

  def index
    render json: Word.order(word_index: :asc)
  end

end

