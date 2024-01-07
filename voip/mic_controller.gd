extends AudioStreamPlayer

@export var label: Label


func _ready() -> void:
	stop()
	label.text = "Press [Q]\nMic is off"


func _input(event: InputEvent) -> void:
	if not is_multiplayer_authority(): return
	
	var	just_pressed = event.is_pressed() and not event.is_echo()
	if Input.is_action_pressed("mic_enable") and just_pressed:
		if playing:
			stop()
			label.text = "Press [Q]\nMic is off"
		else:
			play()
			label.text = "Press [Q]\nMic is on"
