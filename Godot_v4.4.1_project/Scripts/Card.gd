extends Control

func _ready() -> void:
	print("_ready()")

func make_data():
	printt("make_data()")
	var new_card = self.duplicate()
	return new_card

func _get_drag_data(_data_position):
	printt("_get_drag_data(_data_position)", _data_position)
	var mydata = make_data() 
	# This is your custom method generating the drag data.
	set_drag_preview(mydata) 
	# This is your custom method generating the preview of the drag data.
	return mydata

func _can_drop_data(_data_position, data):
	printt("_can_drop_data(position, data)", self, _data_position, data)
	# Check position if it is relevant to you
	# Otherwise, just check data
	return data is Button

func _drop_data(_data_position, data):
	printt("_drop_data(position, data)", _data_position, data)
	# Implement Drop here
	
	
