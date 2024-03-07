extends Label


func _process(_delta: float) -> void:
	if Microphone.is_speaking:
		text = "Speaking..."
		label_settings.font_color = Color.GREEN_YELLOW
	else:
		text = "Press Shift to speak"
		label_settings.font_color = Color.WHITE
