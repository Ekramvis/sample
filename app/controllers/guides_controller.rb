class GuidesController < ApplicationController

  def index
    @posts    = Post.guides.order('date_posted desc').page(params[:page])
    @resource = 'News'
    
    respond_to do |format|
      format.html { render 'posts/index' }
      format.atom { render template: 'posts/index.atom.builder', layout: false }
      format.rss { redirect_to guides_path(format: :atom), status: :moved_permanently }
    end
  end

  def show
    @post = Post.guides.find(params[:id])
    render 'posts/show'
  end

end
