class ResourcesController < ApplicationController

  def index
    @posts    = Post.resources.order('date_posted desc').page(params[:page])
    @resource = 'Resources'
    
    respond_to do |format|
      format.html { render 'posts/index' }
      format.atom { render template: 'posts/index.atom.builder', layout: false }
      format.rss { redirect_to resources_path(format: :atom), status: :moved_permanently }
    end
  end

  def show
    @post = Post.resources.find(params[:id])
    render 'posts/show'
  end

end
