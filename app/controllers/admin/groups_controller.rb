class Admin::GroupsController < Admin::ApplicationController

  inherit_resources

  def index
    @groups = Group.all.order(sort_column + " " + sort_direction).page(params[:page])
  end

  def create
    @group = Group.new(group_params)
    if @group.save
      flash[:success] = 'Category added.'
      redirect_to admin_groups_path
    else
      render :new
    end
  end

  def update
    @group = Group.find(params[:id])
    if @group.update_attributes(group_params)
      flash[:success] = 'Category updated.'
      redirect_to admin_group_path
    else
      render :edit
    end
  end


  private

  def group_params
    params.require(:group).permit(:name, :grid, :background)
  end

  def default_sort_column
    'name'
  end

  def default_direction_column
    'asc'
  end

end
