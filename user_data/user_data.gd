extends Node
class_name UserData

signal speaking_changed(speaking: bool)

@export var speaking: bool:
	set(value):
		speaking = value
		speaking_changed.emit(value)

var id: int


func _process(_delta: float) -> void:
	if not is_multiplayer_authority(): return
	speaking = Microphone.is_speaking
