extends TextureRect


const SEVERE_RANGE: float = 1.0
const MODERATE_RANGE: float = 2.5
const LOW_RANGE: float = 4.0
const NO_SCAN: float = 0.0

const INVIS_COLOR: Color = Color(0,0,0,0)

func _ready() -> void:
	hide()


func _on_scanner_in_hand_detected_mine(distance: Variant) -> void:
	print("MineIcon received: " + str(distance))
	if distance != NO_SCAN:
		show()
	match distance:
		SEVERE_RANGE:
			self_modulate = Color.ORANGE_RED
		MODERATE_RANGE:
			self_modulate = Color.CORAL
		LOW_RANGE:
			self_modulate = Color.YELLOW
		NO_SCAN:
			hide()
	var tween = get_tree().create_tween()
	tween.tween_property(self,"self_modulate",INVIS_COLOR,1.0)
