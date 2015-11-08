class WordGroupsController < ApplicationController

  before_filter :authenticate_user!

  def index
    render json: WordGroup
      .order('(ending_word_id-starting_word_id) DESC', 'starting_word_id ASC')
  end

  def create
    @word_group = WordGroup.new(_create_params)
    if @word_group.save
      render json: @word_group
    else
      render json: @word_group.errors, status: :unprocessable_entity
    end
  end

  def update
    @word_group = WordGroup.find(params[:id])
    if @word_group.update(_update_params)
      render json: @word_group
    else
      render json: @word_group.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @word_group = WordGroup.find(params[:id])
    if @word_group.destroy
      render json: {}
    else
      render json: @word_group.errors, status: :unprocessable_entity
    end
  end

  private

  def _create_params
    params
      .require(:word_group)
      .permit(
        :starting_word_id,
        :ending_word_id,
        :group_type,
        :concept_id
      )
  end

  def _update_params
    params
      .require(:word_group)
      .permit(
        :group_type,
        :concept_id
      )
  end

end

