class Admin::ResourcesController < Admin::ApplicationController

  inherit_resources
  defaults :resource_class => Post.resources,
           :collection_name => 'resources',
           :instance_name => 'resource'

  def new
    @resource = Post.new
    @resource.file_attachments.build
    @groups = Group.all
    super
  end

  def edit
    @resource = Post.find(params[:id])
    @resource.file_attachments.build
    @groups = Group.all
    gon.group_ids = @resource.groups.map(&:id)
    super
  end

  def index
    @resources = Post.resources.order(sort_column + " " + sort_direction).page(params[:page])
  end

  def create
    @resource = current_user.posts.resources.new(resource_param_hash)
    if @resource.save
      add_to_feed @resource
      flash[:success] = 'Resource published.'
      redirect_to admin_resources_path
    else
      @groups = Group.all
      render :new
    end
  end

  def update
    @resource = Post.resources.find(params[:id])
    if @resource.update_attributes(resource_param_hash)
      flash[:success] = 'Resource updated.'
      redirect_to admin_resources_path
    else
      @groups = Group.all
      gon.group_ids = @resource.groups.map(&:id)
      render :edit
    end
  end


  private

  def resource_param_hash
    params.require(:post).permit(:title, :thumbnail, :background, :content, :date_posted, group_ids: [], file_attachments_attributes: [:attachment, :title, :id, :_destroy])
  end

  def default_sort_column
    'date_posted'
  end

  def default_direction_column
    'desc'
  end

end
