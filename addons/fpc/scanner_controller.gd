extends Node3D

signal scanner_placed
signal scanner_picked_up

@export var scanner_object: PackedScene
@export var hand_scanner_mesh: Node3D
@export var camera: Camera3D
@export var placement_range: int

var holding_scanner: bool = true

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("scanner"):
		if holding_scanner:
			try_to_place_scanner()
		else:
			try_to_pickup_scanner()


func try_to_place_scanner() -> void:
	var space_state = get_world_3d().direct_space_state
	var from = camera.global_transform.origin
	var to = from + camera.global_transform.basis.z * -placement_range

	var query = PhysicsRayQueryParameters3D.create(from, to)
	query.collision_mask = 1 # Only detect collisions on layer 1 (terrain)

	var result = space_state.intersect_ray(query)

	if result and result.has("position"):
		pass



func try_to_pickup_scanner() -> void:
	var space_state = get_world_3d().direct_space_state
	var from = camera.global_transform.origin
	var to = from + camera.global_transform.basis.z * -10

	var query = PhysicsRayQueryParameters3D.create(from, to)
	query.collide_with_areas = true
	query.collide_with_bodies = true
	var result = space_state.intersect_ray(query)

	if result and result.has("collider") and result.collider.is_in_group("scanner"):
		print("Pick UP")
