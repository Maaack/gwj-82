@tool
extends Area3D

signal exploded

@export var sfx: AudioStreamPlayer3D

@export_tool_button("Trigger") var trigger_action = trigger
@export_tool_button("Reset") var reset_action = reset

# Used to reference the player when triggered
var player: Node3D

func trigger() -> void:
	%MineMesh.show()
  sfx.play()
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(%MineMesh,"position:y",1.35,0.6)
	await tween.finished
	player.immobile = true
	explode()

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player = body
		trigger()

func explode() -> void:
	print(name + " detonated at " + str(position))
	exploded.emit()

func reset() -> void:
	%MineMesh.hide()
	%MineMesh.position.y = -0.15
