extends Node3D

signal level_won

var level_state : LevelState
var mine_position_map : Dictionary[Node3D, Vector3]

func _on_exit_area_3d_player_exited():
	level_won.emit()

func _on_mine_exploded(node: Node3D):
	var _original_position = mine_position_map[node]
	level_state.mines_removed.append(_original_position)

func open_tutorials() -> void:
	level_state.tutorial_read = true

func _ready() -> void:
	level_state = GameState.get_level_state(scene_file_path)
	var mines := get_tree().get_nodes_in_group(&"mine")
	for mine in mines:
		mine_position_map[mine as Node3D] = mine.global_position
		if mine.global_position in level_state.mines_removed:
			mine.queue_free()
		else:
			mine.exploded.connect(_on_mine_exploded.bind(mine))
