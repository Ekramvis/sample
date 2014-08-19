class Admin::BlogsController < Admin::ApplicationController

  inherit_resources
  defaults :resource_class => Post.blogs,
           :collection_name => 'blogs',
           :instance_name => 'blog'

  def new
    @blog = Post.new
    @blog.file_attachments.build
    @groups = Group.all
    super
  end

  def edit
    @blog = Post.find(params[:id])
    @blog.file_attachments.build
    @groups = Group.all
    gon.group_ids = @blog.groups.map(&:id)
    super
  end

  def index
    @blogs = Post.blogs.order(sort_column + " " + sort_direction).page(params[:page])
  end

  def create
    @blog = current_user.posts.blogs.new(blog_params)
   
    if @blog.save
      add_to_feed @blog
      flash[:success] = 'Blog published.'
      redirect_to admin_blogs_path
    else
      @groups = Group.all
      render :new
    end
  end

  def update
    @blog = Post.blogs.find(params[:id])
   
    if @blog.update_attributes(blog_params)
      flash[:success] = 'Blog post updated.'
      redirect_to admin_blogs_path
    else
      @groups = Group.all
      gon.group_ids = @blog.groups.map(&:id)
      render :edit
    end
  end


  private
    
  def blog_params
    params.require(:post).permit(:title, :thumbnail, :background, :content, :date_posted, group_ids: [], file_attachments_attributes: [:attachment, :title, :id, :_destroy])
  end

  def default_sort_column
    'date_posted'
  end

  def default_direction_column
    'desc'
  end

end
