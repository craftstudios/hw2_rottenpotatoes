module ApplicationHelper

	def sortable(column, title = nil, options = {})
		options[:id] ||= column + '_header'
		# options[:class] = (column == sort_column)? "hilite #{sort_direction}" : nil
		title ||= column.titleize
		direction = column == sort_column && sort_direction == 'asc' ? 'desc' : 'asc'
		link_to title, movies_path(:sort => column, :direction => direction), options
	end
	
	def sort_class(column)
		(column == sort_column)? "hilite #{sort_direction}" : nil
	end
	
end