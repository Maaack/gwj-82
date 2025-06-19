class_name Item3D
extends CharacterBody3D

signal picked_up

func _on_area_3d_body_entered(body : Node3D):
	if body.is_in_group(&"player"):
		picked_up.emit()
		queue_free()
