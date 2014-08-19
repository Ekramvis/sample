class PublicController < ApplicationController
  def index
    gon.download_now = true if params[:download]
  end

  def search
    @results = Search.new(params[:search][:term])
  end

  def faq
    @faqs = Faq.order('position asc')
  end

end
