class Admin::PostersController < Admin::ApplicationController

  inherit_resources

  def index
    @posters = Poster.all.order(sort_column + " " + sort_direction).page(params[:page])
  end

  def new
    @poster = Poster.new
    @poster.build_file_attachment
    @poster.poster_sections.build
    super
  end

  def create
    @poster = Poster.new(poster_params)
    if @poster.save
      flash[:success] = 'Poster added.'
      redirect_to admin_posters_path
    else
      render :new
    end
  end

  def edit
    @poster = Poster.find(params[:id])
    @poster.build_file_attachment unless @poster.file_attachment.present?
    @poster.poster_sections.build
    super
  end

  def update
    @poster = Poster.find(params[:id])
    if @poster.update_attributes(poster_params)
      flash[:success] = 'Poster updated.'
      redirect_to admin_poster_path
    else
      render :edit
    end
  end


  private

  def poster_params
    params.require(:poster).permit(:title, :thumbnail, file_attachment_attributes: [:attachment, :title, :id, :_destroy], poster_sections_attributes: [:title, :description, :image,:page_link, :video_link, :id, :_destroy])
  end

  def default_sort_column
    'created_at'
  end

  def default_direction_column
    'asc'
  end

end
