extends AudioStreamPlayer

func _on_scanner_in_hand_detected_mine(distance: Variant) -> void:
	if distance == 0.0:
		return
	else:
		play()
