  def index
    @<%= plural_name %> = <%= class_name %>.<%= options.paginate? ? "paginate(:page => params[:page])" : "all" %>
  end
