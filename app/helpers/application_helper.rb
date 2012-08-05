module ApplicationHelper
  def sortable(column, title, html_id =nil)
    title ||= column.titleize
    link_to title, {sort: column, ratings: selected_ratings}, {id: html_id}  
  end
end
