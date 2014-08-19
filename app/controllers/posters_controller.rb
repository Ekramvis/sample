class PostersController < ApplicationController

  def index
    @posters = Poster.all.order(sort_column + " " + sort_direction)
  end

  def show
    @poster = Poster.find(params[:id])
  end

private

  def default_sort_column
    'created_at'
  end

  def default_direction_column
    'asc'
  end

end
