extends Control

signal connect_client

@export var hide_ui_and_connect: bool


func _ready():
	if Connection.is_server(): return
	
	if hide_ui_and_connect:
		hide_ui()
		connect_client.emit()


func hide_ui() -> void:
	$MainMenu.visible = false
	$InGameUI.visible = true


func show_ui() -> void:
	$MainMenu.visible = true
	$InGameUI.visible = false
