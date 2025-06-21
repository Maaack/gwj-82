extends Timer

const SEVERE_RANGE: float = 1.0
const MODERATE_RANGE: float = 2.5
const LOW_RANGE: float = 4.0
const NO_SCAN: float = 0.0


func _on_scanner_in_hand_detected_mine(distance: Variant) -> void:
	if distance == NO_SCAN:
		stop()
	else:
		wait_time = distance
		print("Timer started for " + str(distance))
		start()
