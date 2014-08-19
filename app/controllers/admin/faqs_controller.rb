class Admin::FaqsController < Admin::ApplicationController
  inherit_resources

  def new
    super
  end

  def edit
    @faq = Faq.find(params[:id])
    super
  end

  def create
    @faq = Faq.new(faq_params)
    if @faq.save
      flash[:success] = 'FAQ published.'
      redirect_to admin_faqs_path
    else
      render :new
    end
  end

  def update
    @faq = Faq.find(params[:id])
    if @faq.update_attributes(faq_params)
      flash[:success] = 'FAQ updated.'
      redirect_to admin_faqs_path
    else
      render :edit
    end
  end

  def index
    @faqs = Faq.order('position asc').page(params[:page])
  end

  def show
    if request.xhr?
      @faq = Faq.find(params[:id])
      render json: @faq.to_json
    else
      super
    end
  end

  def sort
    params[:sort].each do |k, v|
      Faq.find(k).update(position: v)
    end
    head :ok
  end


  private

  def faq_params
    params.require(:faq).permit!
  end

  def default_sort_column
    'question'
  end

end
