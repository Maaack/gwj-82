class_name GhostSpawner3D
extends Node3D

signal ghost_spawned(ghost : Node3D)

@export var ghost_scene : PackedScene
@export var ghosts_container : Node3D
@export var ring_inner_radius : float
@export var ring_outer_radius : float
@export var spawn_delay : float = 1.0

var level_state : LevelState

func spawn_ghost() -> void:
	var ghost_instance = ghost_scene.instantiate()
	var random_vector := Vector2.from_angle(randf_range(-PI, PI))
	random_vector = random_vector.normalized()
	var random_position := Vector3(random_vector.x, 0, random_vector.y)
	var random_distance := randf_range(ring_inner_radius, ring_outer_radius)
	ghost_instance.position = random_position * random_distance
	ghosts_container.add_child.call_deferred(ghost_instance)
	ghost_spawned.emit(ghost_instance)

func spawn_ghosts(ghost_count : int) -> void:
	for iter in range(ghost_count):
		spawn_ghost()

func _ready() -> void:
	level_state = GameState.get_level_state(get_parent().scene_file_path)
	await get_tree().create_timer(spawn_delay, false).timeout
	spawn_ghosts(level_state.starting_ghosts)
