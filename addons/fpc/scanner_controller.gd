extends Node3D

signal scanner_placed
signal scanner_picked_up

@export var scanner_object: PackedScene
@export var camera: Camera3D
@export var placement_range: int
@export var hand_scanner: Node3D

var scanner
var holding_scanner: bool = true:
	set(state):
		holding_scanner = state
		if holding_scanner:
			hand_scanner.show()
		else:
			hand_scanner.hide()
	get:
		return holding_scanner

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
		place_scanner(result.position)


func place_scanner(_position: Vector3) -> void:
	holding_scanner = false
	
	scanner = scanner_object.instantiate()
	var minefield = get_tree().get_first_node_in_group("item_spawner")
	minefield.add_child(scanner)
	scanner.global_position = _position


func try_to_pickup_scanner() -> void:
	if holding_scanner:
		return
	var space_state = get_world_3d().direct_space_state
	var from = camera.global_transform.origin
	var to = from + camera.global_transform.basis.z * -10

	var query = PhysicsRayQueryParameters3D.create(from, to)
	query.collide_with_areas = true
	var result = space_state.intersect_ray(query)

	if result and result.has("collider") and result.collider.is_in_group("scanner"):
		pickup_scanner()


func pickup_scanner() -> void:
	holding_scanner = true
	
	scanner.queue_free()
