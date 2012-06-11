module ApplicationHelper
	def sortable(column, title = nil)
		title ||= column.titleize
		direction = column == sort_column && sort_direction == 'asc' ? 'desc' : 'asc'
		link_to title, movies_path(:sort => column, :direction => direction)
	end
end
