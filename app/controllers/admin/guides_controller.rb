class Admin::GuidesController < Admin::ApplicationController

  inherit_resources
  defaults :resource_class => Post.guides,
           :collection_name => 'guides',
           :instance_name => 'guide'

  def new
    @guide = Post.new
    @guide.file_attachments.build
    @groups = Group.all
    super
  end

  def edit
    @guide = Post.find(params[:id])
    @guide.file_attachments.build
    @groups = Group.all
    gon.group_ids = @guide.groups.map(&:id)
    super
  end

  def index
    @guides = Post.guides.order(sort_column + " " + sort_direction).page(params[:page])
  end

  def create
    @guide = current_user.posts.guides.new(guide_params)
    
    if @guide.save
      add_to_feed @guide
      flash[:success] = 'News post published.'
      redirect_to admin_guides_path
    else
      @groups = Group.all
      render :new
    end
  end

  def update
    @guide = Post.guides.find(params[:id])

    if request.xhr?
      @guide.update_attributes(guide_params)
      render nothing: true
    else   
      if @guide.update_attributes(guide_params)
        flash[:success] = 'News post updated.'
        redirect_to admin_guides_path
      else
        @groups = Group.all
        gon.group_ids = @guide.groups.map(&:id)
        render :edit
      end
    end
  end


  private

  def guide_params
    params.require(:post).permit(:title, :is_featured, :thumbnail, :background, :content, :date_posted, group_ids: [], file_attachments_attributes: [:attachment, :title, :id, :_destroy])
  end

  def default_sort_column
    'date_posted'
  end

  def default_direction_column
    'desc'
  end

end
