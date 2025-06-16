extends Node3D

signal level_won

var level_state : LevelState

func _on_exit_area_3d_player_exited():
	level_won.emit()

func _on_mine_exploded(node: Node3D):
	level_state.mines_removed.append(node.name)

func open_tutorials() -> void:
	level_state.tutorial_read = true

func _ready() -> void:
	level_state = GameState.get_level_state(scene_file_path)
	var mines := get_tree().get_nodes_in_group(&"mine")
	for mine in mines:
		if mine.name in level_state.mines_removed:
			mine.queue_free()
		else:
			mine.exploded.connect(_on_mine_exploded.bind(mine))
