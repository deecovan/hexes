extends Control

func make_data():
	return null

func make_preview(mydata):
	return null

func _get_drag_data(position):
	var mydata = make_data() 
	# This is your custom method generating the drag data.
	set_drag_preview(make_preview(mydata)) 
	# This is your custom method generating the preview of the drag data.
	return mydata

func _can_drop_data(position, data):
	# Check position if it is relevant to you
	# Otherwise, just check data
	return typeof(data) == TYPE_DICTIONARY and data.has("expected")

func _drop_data(position, data):
	var color = data["color"]
