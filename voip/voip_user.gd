extends Node3D
class_name VoipUser

@export var offset: Vector3

var anchor: Node3D


func set_anchor(_anchor: Node3D) -> void:
	anchor = _anchor


func _physics_process(_delta: float) -> void:
	if not is_instance_valid(anchor): return
	global_position = anchor.global_position + offset
