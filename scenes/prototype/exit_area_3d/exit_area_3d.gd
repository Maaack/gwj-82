extends Area3D

signal player_exited

@export var player_group_name : StringName = &"player"

func _on_body_entered(body : Node3D):
	if body and body.is_in_group(player_group_name):
		player_exited.emit()

func _on_body_exited(body):
	pass

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
