extends VBoxContainer

@export var user_data_events: UserDataEvents
@export var player_panel: PackedScene


func _ready() -> void:
	user_data_events.user_data_spawned.connect(user_data_spawned)
	user_data_events.user_data_despawned.connect(user_data_despawned)


func user_data_spawned(id: int, user_data: UserData) -> void:
	var p: PlayerPanel = player_panel.instantiate() as PlayerPanel
	p.set_user_data(user_data)
	p.name = str(id)
	add_child(p)


func user_data_despawned(id: int) -> void:
	get_node(str(id)).queue_free()
