extends Node3D
class_name VoiceInstance

@export var mic: MicController
@export var audio: AudioStreamPlayer

var mic_capture: VOIPInputCapture


func _ready() -> void:
	if not is_multiplayer_authority(): return
	var mic_bus = AudioServer.get_bus_index("Record")
	mic_capture = AudioServer.get_bus_effect(mic_bus, 0) as VOIPInputCapture
	mic_capture.packet_ready.connect(voice_packet_ready)


func _process(_delta: float) -> void:
	if not is_multiplayer_authority(): return
	
	mic_capture.send_test_packets()


func voice_packet_ready(packet : PackedByteArray) -> void:
	if not mic.enabled: return
	
	var connection_status = multiplayer.multiplayer_peer.get_connection_status()
	if connection_status != MultiplayerPeer.CONNECTION_CONNECTED: return
	
	voice_packet_received.rpc(packet)


@rpc("call_remote", "unreliable")
func voice_packet_received(packet : PackedByteArray):
	if multiplayer.is_server(): return
	audio.stream.push_packet(packet)
