class Admin::DownloadsController < Admin::ApplicationController

  inherit_resources

  def index
    @downloads = Download.all.order(sort_column + " " + sort_direction).page(params[:page])
  end

  def new
    @download = Download.new
    @download.build_file_attachment
    super
  end

  def create
    @download = Download.new(download_params)
    if @download.save
      flash[:success] = 'Download added.'
      redirect_to admin_downloads_path
    else
      @download.build_file_attachment unless @download.file_attachment.present?
      render :new
    end
  end

  def edit
    @download = Download.find(params[:id])
    @download.build_file_attachment unless @download.file_attachment.present?
    super
  end

  def update
    @download = Download.find(params[:id])
    if @download.update_attributes(download_params)
      flash[:success] = 'Download updated.'
      redirect_to admin_download_path
    else
      @download.build_file_attachment unless @download.file_attachment.present?
      render :edit
    end
  end


  private

  def download_params
    params.require(:download).permit(file_attachment_attributes: [:attachment, :title, :id, :_destroy])
  end

  def default_sort_column
    'created_at'
  end

  def default_direction_column
    'asc'
  end

end
