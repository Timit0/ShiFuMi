extends Node

var network = ENetMultiplayerPeer.new();
var ip
var port

signal change_to_this_scene_signal
signal change_to_winner_scene_signal
signal add_in_queue_signal
signal play_this_animation_signal
signal play_animation_idle_signal
signal play_this_hand_animation_signal

var clients : Dictionary

func _ready():
	load_server_config()
	ConnectToServer();
	add_in_queue_signal.connect(_on_add_in_queue)
	
func ConnectToServer() -> void:
	network.create_client(ip, port);
	multiplayer.multiplayer_peer = network;
	network.peer_connected.connect(_on_connection_succeeded);
	network.peer_disconnected.connect(_on_connection_failed);

func _on_connection_failed(id):
	print("Failed to connect to "+str(id));
	
func _on_connection_succeeded(id):
	print("Succesfully connected to "+str(id))
	Client_Status.is_connected_to_serv = true;
	
func get_id() -> int:
	return network.get_unique_id();

func load_server_config()->void:
	var file = FileAccess.open("res://ServerConfig/ServerConfig.txt", FileAccess.READ)
	var content = file.get_as_text()
	ip = content.split(";")[0]
	port = int(content.split(";")[1])
	
@rpc
func _on_add_in_queue():
	rpc_id(1, "_on_add_in_queue", get_id())
	
@rpc("authority")
func update_clients_dic(dic : Dictionary):
	clients = dic
	
@rpc
func send_choice_from_client_to_serv(choice : String):
	rpc_id(1, "send_choice_from_client_to_serv", get_id(), choice)
	
@rpc("authority")
func play_this_hand_animation(clients : Dictionary):
	play_this_hand_animation_signal.emit(clients)
	
@rpc("authority")
func play_this_animation(anim_name : String, state_string : String):
	play_this_animation_signal.emit(anim_name, state_string)
	
@rpc("authority")
func play_hand_idle():
	play_animation_idle_signal.emit()
	
@rpc("authority")
func go_to_this_scene(scene_name : String, args : Dictionary):
	change_to_this_scene_signal.emit(scene_name, args)
