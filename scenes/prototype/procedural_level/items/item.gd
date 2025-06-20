class_name Item3D
extends CharacterBody3D

signal picked_up

func pick_up() -> void:
	picked_up.emit()
	queue_free()

func _on_area_3d_body_entered(body : Node3D) -> void:
	if body.is_in_group(&"player"):
		pick_up()
