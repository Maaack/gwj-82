extends Area3D

signal exploded

# Used to reference the player when triggered
var player: Node3D

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player = body
		var tween = get_tree().create_tween()
		tween.tween_property(self,"position:y",2.0,0.2)
		await tween.finished
		player.immobile = true
		explode()

func explode() -> void:
	##TODO Play SFX
	print(name + " detonated at " + str(position))
	exploded.emit()
