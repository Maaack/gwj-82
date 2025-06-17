extends Node

@export var zone_scenes : Array[PackedScene] = []
@export var zone_size : Vector2 = Vector2.ZERO
@export var level_zone_size : Vector2 = Vector2.ZERO
@export var offset : Vector2 = Vector2.ZERO
@export var zone_container : Node3D

var level_state : LevelState
var _level_built : bool = false

func _build_level() -> void:
	if _level_built: return
	_level_built = true
	var level_tiles : Array[PackedScene]
	if level_state.level_tiles.size() == level_zone_size.x * level_zone_size.y:
		level_tiles = level_state.level_tiles
	else:
		var shuffled_tiles := zone_scenes.duplicate()
		shuffled_tiles.shuffle()
		for tile_x in range(level_zone_size.x):
			for tile_y in range(level_zone_size.y):
				var next_tile : PackedScene = shuffled_tiles.pop_back()
				level_tiles.append(next_tile)
		level_state.level_tiles = level_tiles
	var iter = 0
	for tile_x in range(level_zone_size.x):
		for tile_y in range(level_zone_size.y):
			if iter > level_tiles.size():
				return
			var next_tile = level_tiles[iter]
			iter += 1
			var tile_instance : Node3D = next_tile.instantiate()
			var tile_position_x : float = (zone_size.x * tile_x) + offset.x
			var tile_position_z : float = (zone_size.y * tile_y) + offset.y
			tile_instance.position = Vector3(tile_position_x, 0, tile_position_z)
			zone_container.add_child(tile_instance)

func _ready():
	level_state = GameState.get_level_state(get_parent().scene_file_path)
	_build_level()
