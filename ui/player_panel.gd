extends Control
class_name PlayerPanel

@export var volume_slider: HSlider
@export var user_data_events: UserDataEvents

var user_data: UserData


func _ready() -> void:
	volume_slider.value_changed.connect(send_volume_changed)


func set_user_data(_user_data: UserData) -> void:
	user_data = _user_data


func send_volume_changed(volume: float) -> void:
	user_data_events.user_volume_changed_emit(user_data.id, volume)
