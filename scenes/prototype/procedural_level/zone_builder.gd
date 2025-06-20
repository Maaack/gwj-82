class_name ZoneBuilder
extends Node

signal zone_added(zone : Node3D)
signal level_built
signal item_added(item : Node3D)

@export var zone_scenes : Array[PackedScene] = []
@export var zone_size : Vector2 = Vector2.ZERO
@export var level_zone_size : Vector2 = Vector2.ZERO
@export var offset : Vector2 = Vector2.ZERO
@export var zone_container : Node3D
@export var item_scenes : Array[PackedScene] = []

var level_state : LevelState
var zone_state : ZoneState
var _level_built : bool = false

func _place_item() -> void:
	if item_scenes.is_empty(): return
	var item_spawners = get_tree().get_nodes_in_group(&"item_spawner")
	if item_spawners.is_empty(): return
	var random_spawn : Node3D = item_spawners.pick_random()
	var random_item : PackedScene = item_scenes.pick_random()
	var item_instance : Node3D = random_item.instantiate()
	zone_container.add_child.call_deferred(item_instance)
	await item_instance.ready
	item_added.emit(item_instance)
	item_instance.global_position = random_spawn.global_position

func _build_level() -> void:
	if _level_built: return
	_level_built = true
	var builder_zones : Array[PackedScene]
	if zone_state.zones.size() == level_zone_size.x * level_zone_size.y:
		builder_zones = zone_state.zones
	else:
		var _shuffled_zones := zone_scenes.duplicate()
		_shuffled_zones.shuffle()
		for tile_x in range(level_zone_size.x):
			for tile_y in range(level_zone_size.y):
				var _next_zone : PackedScene = _shuffled_zones.pop_back()
				builder_zones.append(_next_zone)
		zone_state.zones = builder_zones
	var iter = 0
	for tile_x in range(level_zone_size.x):
		for tile_y in range(level_zone_size.y):
			if iter > builder_zones.size():
				return
			var _next_zone = builder_zones[iter]
			iter += 1
			var tile_instance : Node3D = _next_zone.instantiate()
			var tile_position_x : float = (zone_size.x * tile_x) + offset.x
			var tile_position_z : float = (zone_size.y * tile_y) + offset.y
			tile_instance.position = Vector3(tile_position_x, 0, tile_position_z)
			zone_container.add_child(tile_instance)
			zone_added.emit(tile_instance)
	level_built.emit()

func _ready():
	level_state = GameState.get_level_state(get_parent().scene_file_path)
	zone_state = level_state.get_zone_state(name)
	_build_level()
	_place_item()
