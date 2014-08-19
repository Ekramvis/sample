class GroupsController < ApplicationController

  def index
    @groups = Group.all.order(sort_column + " " + sort_direction)
  end

  def show
    @group = Group.find(params[:id])
  end

private

  def default_sort_column
    'name'
  end

  def default_direction_column
    'asc'
  end

end
