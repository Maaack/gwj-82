class_name ItemInteractionRayCast3D
extends RayCast3D

signal item_found(item : Item3D)
signal item_lost(item : Item3D)

var detected_item : Item3D

func _process(delta):
	if is_colliding():
		var collider = get_collider()
		if collider is Item3D:
			if detected_item and detected_item != collider:
				item_lost.emit(detected_item)
				detected_item = null
			if detected_item == null:
				detected_item = collider
				item_found.emit(detected_item)
	elif detected_item:
		item_lost.emit(detected_item)
		detected_item = null

func _unhandled_input(event : InputEvent) -> void:
	if event.is_action_pressed(&"interact"):
		if detected_item:
			detected_item.pick_up()
			item_lost.emit(detected_item)
			detected_item = null
