extends MultiplayerSpawner

@export var player_scene: PackedScene
@export var spawn_points: Node3D


func _ready() -> void:
	spawn_function = custom_spawn
	multiplayer.peer_connected.connect(create_player)
	multiplayer.peer_disconnected.connect(destroy_player)


func create_player(id: int):
	if not multiplayer.is_server(): return
	
	var i = randi() % spawn_points.get_children().size()
	var spawn_point = spawn_points.get_children()[i] as Node3D
	spawn([id, spawn_point.position])
#	print("Player %d spawned at " % [id] + str(spawn_point.position))


func custom_spawn(vars) -> Node:
	var id = vars[0]
	var pos = vars[1]
	
	var p: Player = player_scene.instantiate()
	p.set_multiplayer_authority(id)
	p.name = str(id)
	p.position = pos
	return p


func destroy_player(id: int):
	if not multiplayer.is_server(): return
	get_node(spawn_path).get_node(str(id)).queue_free()
#	print("Player %d leaved" % [id])
