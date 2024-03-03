extends Node
class_name Server

var network = ENetMultiplayerPeer.new()
var port = 1909;
var max_players = 100;

var queue : Array = [];

var game_scene = preload("res://Server/Game/Game.tscn")

func _ready() -> void:
	StartServer();

func _input(event):
	if(Input.is_action_just_pressed("ui_accept")):
		for i in queue:
			print(i)
	
func _process(delta):
	if(queue.size() > 0 && queue.size() % 2 == 0):
		var queue_len = queue.size() - 1;
		
		var client_values : Dictionary = {"score" : 5}
		var clients : Dictionary = {queue[queue_len] : client_values, queue[queue_len - 1] : client_values}
		
		queue.remove_at(queue_len)
		queue.remove_at(queue_len-1)
		
		var instance_of_game_scene = game_scene.instantiate() as Game
		instance_of_game_scene.clients = clients;
		add_child(instance_of_game_scene)
	
func StartServer() -> void:
	network.create_server(port, max_players);
	multiplayer.multiplayer_peer = network;
	print("server started");
	
	network.peer_connected.connect(_peer_connected);
	network.peer_disconnected.connect(_peer_disconnected);

func _peer_connected(player_id) -> void :
	print("User " + str(player_id) + " Connected");
	#queue.append(player_id);

func _peer_disconnected(player_id) -> void :
	print("User " + str(player_id) + " Disconnected");
	if(queue.has(player_id)):
		var index_in_queue = queue.find(player_id);
		queue.remove_at(index_in_queue);
	
@rpc("any_peer")
func _on_add_in_queue(client_id : int) -> void:
	if(!queue.has(client_id)):
		queue.append(client_id)
		print(str(client_id)+" has join the queue.")
	
@rpc("any_peer")
func print_on_serv(message: String):
	print(message);
	
@rpc("call_remote")
func print_on_client(player_id: int):
	rpc_id(player_id, "print_on_client", "AAAAAAAAAAAAAAA");

@rpc("call_remote")
func go_to_game_scene(id : int):
	rpc_id(id, "go_to_game_scene");
	
@rpc("call_remote")
func update_clients_dic(id : int, dic : Dictionary):
	rpc_id(id, "update_clients_dic", dic)
	
