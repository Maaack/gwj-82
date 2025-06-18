extends Area3D

signal exploded

@export var sfx: AudioStreamPlayer3D

# Used to reference the player when triggered
var player: Node3D

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player = body
		sfx.play()
		var tween = get_tree().create_tween()
		tween.tween_property(self,"position:y",1.25,0.6).set_trans(Tween.TRANS_BACK)
		await tween.finished
		player.immobile = true
		explode()

func explode() -> void:
	print(name + " detonated at " + str(position))
	exploded.emit()
