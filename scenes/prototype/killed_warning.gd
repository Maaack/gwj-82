extends Control


const KILLED_BY_MINE_STRING = "Killed by a mine."
const KILLED_BY_GHOST_STRING = "Killed by a ghost."

@export var warning_panel: PanelContainer
@export var killed_label : Label

@onready var active_mines: Array = get_tree().get_nodes_in_group(&"mine")
@onready var active_ghosts: Array = get_tree().get_nodes_in_group(&"ghost")

func _ready() -> void:
	for mine in active_mines:
		mine.exploded.connect(_on_killed_by_mine)
	for ghost in active_ghosts:
		ghost.killed.connect(_on_killed_by_ghost)

func _on_killed_by_mine() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	killed_label.text = KILLED_BY_MINE_STRING
	warning_panel.show()

func _on_killed_by_ghost() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	killed_label.text = KILLED_BY_GHOST_STRING
	warning_panel.show()

func _on_try_again_button_pressed() -> void:
	get_tree().reload_current_scene()
