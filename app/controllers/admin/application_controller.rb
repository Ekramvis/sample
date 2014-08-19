class Admin::ApplicationController < ApplicationController

  layout 'admin'
  before_filter :require_user!
  before_filter :require_admin!


  private

  def permitted_params
    params.permit!
  end

  def sort_column
    resource_class.column_names.include?(params[:sort]) ? params[:sort] : default_sort_column
  end
  helper_method :sort_column

end