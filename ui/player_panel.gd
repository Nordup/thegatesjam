extends Control
class_name PlayerPanel

@export var volume_slider: HSlider
@export var speaking_indicator: Control
@export var user_data_events: UserDataEvents

var user_data: UserData


func _ready() -> void:
	volume_slider.value_changed.connect(send_volume_changed)
	speaking_indicator.visible = false


func send_volume_changed(volume: float) -> void:
	user_data_events.user_volume_changed_emit(user_data.id, volume)


func set_user_data(_user_data: UserData) -> void:
	user_data = _user_data
	user_data.speaking_changed.connect(speaking_changed)


func speaking_changed(speaking: bool) -> void:
	speaking_indicator.visible = speaking
