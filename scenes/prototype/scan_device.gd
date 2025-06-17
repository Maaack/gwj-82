extends Node3D

enum ScannerLocation{HELD,PLACED}

@export var scan_radius: float = 5.0
@export var min_beep_interval: float = 0.2
@export var max_beep_interval: float = 4.0
@export var max_effective_distance: float = 5.0
@export var scanner_mesh: Node3D
@export var beep_audio: AudioStreamPlayer
@export var flash_light: OmniLight3D
@export var camera: Camera3D
@export var pickup_range: float = 2.0
@export var held_position: Vector3
@export var held_rotation: Vector3

var is_scanning: bool = false
var scan_position: Vector3
var scan_rotation: Vector3
var scan_timer: Timer
var scanner_original_transform: Transform3D
var scanner_held: bool = true


func _ready():
	move_scanner(held_position, held_rotation)
	scan_timer = Timer.new()
	scan_timer.one_shot = false
	scan_timer.connect("timeout", Callable(self, "_on_scan_timer_timeout"))
	add_child(scan_timer)
	flash_light.visible = false


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("place_scanner"):
		if scanner_held:
			try_place_scanner()
		else:
			try_pickup_scanner()


func move_scanner(_position: Vector3, _rotation: Vector3) -> void:
	scanner_mesh.position = _position
	scanner_mesh.rotation_degrees = _rotation


func try_place_scanner():
	var space_state = get_world_3d().direct_space_state
	var from = camera.global_transform.origin
	var to = from + camera.global_transform.basis.z * -10

	var query = PhysicsRayQueryParameters3D.create(from, to)
	query.collision_mask = 1 # Only detect collisions on layer 1 (terrain)

	var result = space_state.intersect_ray(query)

	if result and result.has("position"):
		var distance = result.position.distance_to(camera.global_transform.origin)
		if distance <= pickup_range:
			scan_position = result.position
			scan_rotation = result.normal
			scanner_original_transform = scanner_mesh.global_transform
			scanner_mesh.reparent(get_tree().root) # Re-parent to world
			scanner_mesh.global_transform.origin = scan_position
			scanner_mesh.global_rotation_degrees = Vector3.ZERO
			start_scanning()


func start_scanning():
	if scanner_held:
		scanner_held = false
		is_scanning = true
		scanner_mesh.visible = true
		_set_scan_timer_interval()
		scan_timer.start()


func try_pickup_scanner():
	if scanner_held:
		return

	var space_state = get_world_3d().direct_space_state
	var from = camera.global_transform.origin
	var to = from + camera.global_transform.basis.z * -10

	var query = PhysicsRayQueryParameters3D.create(from, to)
	query.collision_mask = 1
	var result = space_state.intersect_ray(query)

	if result and result.has("position"):
		var distance = scanner_mesh.global_transform.origin.distance_to(camera.global_transform.origin)
		if distance <= pickup_range:
			stop_scanning()
			scanner_mesh.reparent(camera) # Return scanner to player
			scanner_mesh.global_transform = scanner_original_transform
			scanner_held = true


func stop_scanning():
	is_scanning = false
	scan_timer.stop()
	flash_light.visible = false
	scanner_mesh.visible = false

func _set_scan_timer_interval():
	var mines = get_mines_in_range(scan_position)
	var total_score = 0.0
	for mine in mines:
		var dist = mine.global_transform.origin.distance_to(scan_position)
		var contribution = 1.0 - clamp(dist / max_effective_distance, 0.0, 1.0)
		total_score += contribution

	# Normalize total_score to intensity between 0 and 1, higher = more urgent
	var intensity = clamp(total_score, 0.0, 3.0) / 3.0 # assumes 3+ close mines is max urgency
	var interval = lerp(min_beep_interval, max_beep_interval, 1.0 - intensity)
	scan_timer.wait_time = interval


func _on_scan_timer_timeout():
	_set_scan_timer_interval()
	flash_light.visible = true
	flash_light.light_energy = 4.0
	beep_audio.play()
	await get_tree().create_timer(0.1).timeout
	flash_light.visible = false

func get_mines_in_range(origin: Vector3) -> Array:
	var found = []
	for body in get_tree().get_nodes_in_group("mine"):
		if body.global_transform.origin.distance_to(origin) <= scan_radius:
			found.append(body)
	return found

# Call try_place_scanner() when Use input is pressed and you're aiming at valid ground.
