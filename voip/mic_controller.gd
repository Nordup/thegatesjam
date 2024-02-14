extends AudioStreamPlayer
class_name MicController

@export var label: Label

var enabled : bool = false


func _ready() -> void:
	label.text = "Press [Q]\nMic is off"


func _input(event: InputEvent) -> void:
	if not is_multiplayer_authority(): return
	
	var	just_pressed = event.is_pressed() and not event.is_echo()
	if Input.is_action_pressed("mic_enable") and just_pressed:
		if enabled: label.text = "Press [Q]\nMic is off"
		else: label.text = "Press [Q]\nMic is on"
		enabled = !enabled
