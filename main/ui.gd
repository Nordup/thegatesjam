extends Control

signal connect_client

@export var hide_ui_and_connect: bool


func _ready():
	if Connection.is_server(): return
	
	if hide_ui_and_connect:
		visible = false
		connect_client.emit()


func hide_ui() -> void:
	visible = false


func show_ui() -> void:
	visible = true
