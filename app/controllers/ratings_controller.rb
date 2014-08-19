class RatingsController < ApplicationController

  before_filter :require_user!
  before_filter :get_parent

  def new
    @rating = Rating.new
  end

  def create
    @rating = current_user.ratings.new(rating_params)
    @rating.rateable = @parent
    if @rating.save
      flash[:success] = 'Thank you! Your review and rating have been added.'
      redirect_to @parent
    else
      render :new
    end
  end

  def edit
    @rating = current_user.ratings.find(params[:id])
  end

  def update
    @rating = current_user.ratings.find(params[:id])
    if @rating.update_attributes(rating_params)
      flash[:success] = 'Thank you! Your review and rating have been updated.'
      redirect_to @parent
    else
      render :edit
    end
  end

  def destroy
    @rating = current_user.ratings.find(params[:id])
    @rating.destroy
    flash[:success] = 'Your rating has been removed.'
    redirect_to @parent
  end


  private

  def get_parent
    params.each do |name, value|
      if name =~ /(.+)_id$/ && Rating::ALLOWED_TYPES.include?($1.classify)
        @parent = $1.classify.constantize.find(value)
      end
    end
    raise ArgumentError if !@parent
  end

  def rating_params
    params.require(:rating).permit(:rating, :review)
  end

end