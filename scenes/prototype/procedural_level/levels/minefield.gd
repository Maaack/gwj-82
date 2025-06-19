extends Node3D

signal level_won

@export var zone_builder : ZoneBuilder

var level_state : LevelState
var mine_position_map : Dictionary[Node3D, Vector3]
var item_recovered : bool = false

func _on_item_picked_up():
	item_recovered = true

func _on_exit_area_3d_player_exited():
	if item_recovered:
		level_won.emit()

func _on_mine_exploded(node: Node3D):
	var _original_position = mine_position_map[node]
	level_state.mines_removed.append(_original_position)
	level_state.starting_ghosts += 1

func open_tutorials() -> void:
	level_state.tutorial_read = true

func _on_item_added(item : Item3D) -> void:
	item.picked_up.connect(_on_item_picked_up)

func _ready() -> void:
	level_state = GameState.get_level_state(scene_file_path)
	var mines := get_tree().get_nodes_in_group(&"mine")
	for mine in mines:
		mine_position_map[mine as Node3D] = mine.global_position
		if mine.global_position in level_state.mines_removed:
			mine.queue_free()
		else:
			mine.exploded.connect(_on_mine_exploded.bind(mine))
	zone_builder.item_added.connect(_on_item_added)
