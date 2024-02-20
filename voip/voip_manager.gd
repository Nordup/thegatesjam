extends Node

@export var user: PackedScene

var mic_capture: VOIPInputCapture
var users = {} # {Peer ID: AudioStreamPlayer}


func _ready() -> void:
	if Connection.is_server(): return
	
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	
	var mic_bus = AudioServer.get_bus_index("Record")
	mic_capture = AudioServer.get_bus_effect(mic_bus, 0)
	mic_capture.packet_ready.connect(voice_packet_ready)


func peer_connected(id) -> void:
	if id == 1: return
	
	print("Voip user added ", id)
	users[id] = user.instantiate()
	add_child(users[id], true)


func peer_disconnected(id) -> void:
	if id == 1: return
	
	print("Voip user removed ", id)
	users[id].queue_free()
	users.erase(id)


func voice_packet_ready(packet) -> void:
	if multiplayer.multiplayer_peer.get_connection_status() == MultiplayerPeer.CONNECTION_CONNECTED:
		rpc("voice_packet_received", packet)


@rpc("any_peer", "call_remote", "unreliable_ordered", 1)
func voice_packet_received(packet) -> void:
	if multiplayer.is_server(): return
	
	var sender_id = multiplayer.get_remote_sender_id()
	users[sender_id].stream.push_packet(packet)


func _process(_delta) -> void:
	if multiplayer.is_server(): return
	
	mic_capture.send_test_packets()
