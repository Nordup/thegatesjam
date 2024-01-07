extends Node3D
class_name VoiceInstance

@export var mic: AudioStreamPlayer
@export var audio: AudioStreamPlayer3D

@export_range(0, 1) var input_threshold = 0.1

var record_effect: AudioEffectCapture
var playback : AudioStreamGeneratorPlayback

var buffer := PackedFloat32Array()


func _ready() -> void:
	if multiplayer.is_server(): return
	
	var record_bus_index = AudioServer.get_bus_index("Record")
	record_effect = AudioServer.get_bus_effect(record_bus_index, 0) as AudioEffectCapture


func _process(_delta: float) -> void:
	if multiplayer.is_server(): return
	
	if is_multiplayer_authority():
		send_mic()
	else:
		play_audio()


func send_mic() -> void:
	var stereo_data = record_effect.get_buffer(record_effect.get_frames_available())
	if stereo_data.size() > 0:
		var data = PackedFloat32Array()
		data.resize(stereo_data.size())
		
		var max_value := 0.0
		for i in range(stereo_data.size()):
			var value = (stereo_data[i].x + stereo_data[i].y) / 2.0
			max_value = max(value, max_value)
			data[i] = value
		if max_value < input_threshold:
			return
		
		rpc_id(1, "server_handle", data)


@rpc("unreliable_ordered")
func server_handle(data: PackedFloat32Array) -> void:
	var sender = multiplayer.get_remote_sender_id()
	for peer in multiplayer.get_peers():
		if peer == sender: continue
		rpc_id(peer, "push_buffer", data)


@rpc("any_peer", "unreliable_ordered")
func push_buffer(data: PackedFloat32Array):
	buffer.append_array(data)


func play_audio() -> void:
	if buffer.is_empty(): return
	
	if not audio.playing:
		audio.play()
		playback = audio.get_stream_playback()
	if playback.get_frames_available() < 1: return
	
	for i in range(min(playback.get_frames_available(), buffer.size())):
		playback.push_frame(Vector2(buffer[0], buffer[0]))
		buffer.remove_at(0)
