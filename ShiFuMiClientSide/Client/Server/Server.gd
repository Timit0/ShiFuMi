extends Node

var network = ENetMultiplayerPeer.new();
var ip = "127.0.0.1";
var port = 1909;

signal change_to_this_scene_signal
signal add_in_queue_signal

var clients : Dictionary

func _ready():
	ConnectToServer();
	add_in_queue_signal.connect(_on_add_in_queue)
	
func ConnectToServer() -> void:
	network.create_client(ip, port);
	multiplayer.multiplayer_peer = network;
	network.peer_connected.connect(_on_connection_succeeded);
	network.peer_disconnected.connect(_on_connection_failed);
	
func _input(_event):
	if(Input.is_action_just_pressed("ui_accept")):
		print_on_serv("aaaaaa");

func _on_connection_failed(id):
	print("Failed to connect to "+str(id));
	
func _on_connection_succeeded(id):
	print("Succesfully connected to "+str(id))
	Client_Status.is_connected_to_serv = true;
	
func get_id() -> int:
	return network.get_unique_id();
	
@rpc
func _on_add_in_queue():
	rpc_id(1, "_on_add_in_queue", get_id())
	
#Call print_on_serv() on the server side
@rpc
func print_on_serv(message: String):
	if(!Client_Status.is_connected_to_serv):
		return;
	rpc("print_on_serv", message +" From " + str(network.get_unique_id()));
	
@rpc("authority")
func print_on_client(message: String):
	print(message)
	
@rpc("authority")
func go_to_game_scene():
	change_to_this_scene_signal.emit("game_scene")
	
@rpc("authority")
func update_clients_dic(dic : Dictionary):
	print(dic)
	clients = dic
	
@rpc
func send_choice_from_client_to_serv(choice : String):
	rpc_id(1, "send_choice_from_client_to_serv", get_id(), choice)
	
	
	
	
	
	
	
	
	
	
	
	
	
