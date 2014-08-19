class Admin::SlidesController < Admin::ApplicationController

  inherit_resources

  def index
    @slides = Slide.order('position asc').page(params[:page])
  end

  def sort
    params[:sort].each do |k, v|
      Slide.find(k).update(position: v)
    end
    head :ok
  end

end
