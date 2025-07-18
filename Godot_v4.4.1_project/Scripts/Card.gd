extends Button

func _get_drag_data(_data_position):
	printt("_get_drag_data(_data_position)", _data_position)
	# This is your custom method generating the drag data.
	set_drag_preview(self.duplicate()) 
	# This is your custom method generating the preview of the drag data.
	return self
