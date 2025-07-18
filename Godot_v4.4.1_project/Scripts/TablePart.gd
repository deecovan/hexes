extends HBoxContainer

func _can_drop_data(_data_position, data):
	printt("_can_drop_data(position, data)", self, _data_position, data)
	# Check position if it is relevant to you
	# Otherwise, just check data
	return data is Button

func _drop_data(_data_position, data):
	printt("_drop_data(position, data)", _data_position, data)
	# Implement Drop here
	add_child(data.duplicate(), true)
	data.queue_free()
