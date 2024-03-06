extends Node
class_name Server

var network = ENetMultiplayerPeer.new()
var port = 1909;
var max_players = 100;

var queue : Array = [];
var client_connected : Array = [];

var game_scene = preload("res://Server/Game/Game.tscn")

func _ready() -> void:
	StartServer();
	
func _process(delta):
	if(queue.size() > 0 && queue.size() % 2 == 0):
		var queue_len = queue.size() - 1;
		
		var client_values : Dictionary = {"score" : 0, "client_choice" : null}
		var clients : Dictionary = {queue[queue_len] : client_values.duplicate(), queue[queue_len - 1] : client_values.duplicate()}
		
		queue.remove_at(queue_len)
		queue.remove_at(queue_len-1)
		
		var instance_of_game_scene = game_scene.instantiate() as Game
		print(instance_of_game_scene)
		print(instance_of_game_scene.clients)
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
	client_connected.append(player_id)

func _peer_disconnected(player_id) -> void :
	print("User " + str(player_id) + " Disconnected");
	if(queue.has(player_id)):
		var index_in_queue = queue.find(player_id);
		queue.remove_at(index_in_queue);
	if client_connected.has(player_id):
		var index_in_queue = client_connected.find(player_id);
		client_connected.remove_at(index_in_queue);
	
@rpc("any_peer")
func _on_add_in_queue(client_id : int) -> void:
	if(!queue.has(client_id)):
		queue.append(client_id)
		print(str(client_id)+" has join the queue.")

#@rpc("call_remote")
#func go_to_game_scene(id : int):
	#if client_connected.has(id):
		#rpc_id(id, "go_to_game_scene");
	#
#@rpc("call_remote")
#func go_to_game_winner(id : int, winner_id):
	#if client_connected.has(id):
		#rpc_id(id, "go_to_game_winner", winner_id);
	
@rpc("call_remote")
func update_clients_dic(id : int, dic : Dictionary):
	if client_connected.has(id):
		rpc_id(id, "update_clients_dic", dic)
	
@rpc("any_peer")
func send_choice_from_client_to_serv(id : int, choice : String):
	var childrens = get_children()
	for child in childrens:
		if child is GameModel:
			for key in child.clients:
				if key == id:
					child.clients[key]["client_choice"] = choice
					return

@rpc("call_remote")
func play_this_animation(id : int, anim_name : String, state_string : String):
	if client_connected.has(id):
		rpc_id(id, "play_this_animation", anim_name, state_string)
		
#@rpc("call_remote")
#func go_to_lobby_scene(id : int):
	#if client_connected.has(id):
		#rpc_id(id, "go_to_lobby_scene")
		
@rpc("call_remote")
func go_to_this_scene(client_id : int, scene_name : String, args : Dictionary):
	if client_connected.has(client_id):
		rpc_id(client_id, "go_to_this_scene", scene_name, args)
	
