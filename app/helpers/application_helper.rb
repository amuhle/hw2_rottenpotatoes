module ApplicationHelper
  def sortable(column, title, html_id =nil)
    title ||= column.titleize
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, {sort: column, direction: direction, ratings: selected_ratings}, {id: html_id}  
  end
end
