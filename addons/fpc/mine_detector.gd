extends Area3D

@export var scan_input: String = "scan_for_mine"


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed(scan_input):
		print("Scanning...")
		var mines_in_range = get_overlapping_areas()
		await get_tree().create_timer(2).timeout
		print(str(mines_in_range.size()) + " mines in range.")
