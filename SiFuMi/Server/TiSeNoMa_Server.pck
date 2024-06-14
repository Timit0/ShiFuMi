GDPC                �                                                                         P   res://.godot/exported/950008424/export-218a8f2b3041327d8a5756f3a245f83b-icon.resp!      '      ��0<�iP�A.i��c    T   res://.godot/exported/950008424/export-2681ef127eab13786f1a4502a39e9ef8-Server.scn         u      0��Һ&��ėC$M�    P   res://.godot/exported/950008424/export-3ef6491e731a3e7a1986926f76805cfa-Game.scn�      g      `��R(�^�,6Gm    ,   res://.godot/global_script_class_cache.cfg  �#      �      B���e�<I�y�6       res://.godot/uid_cache.bin  �(      n       �N��<�]{ė�	��    (   res://Script/Server/Model/GameModel.gd          l       ^���=��2:��D��       res://Server/Game/Game.gd   p       ~      �� �!�w��"��.7    $   res://Server/Game/Game.tscn.remap   �"      a       ���(KWC�o��F       res://Server/Main/Server.gd `      �      ��5^�j���:��*    $   res://Server/Main/Server.tscn.remap #      c       �	�U��S/:�+�       res://icon.svg  %      �      C��=U���^Qu��U3       res://icon.svg.import   �       �       �~�򒫘�r��,�       res://project.binary@)      ;      �l"co��	�S�        extends Node
class_name GameModel

#key -> client_id
#value -> client_values
var clients : Dictionary = {};
    extends GameModel
class_name Game

var server : Server

var timer_in : Timer
var timer_start : Timer
var timer_end : Timer
var timer_hand : Timer

var winner : String = ""

func _ready():
	timer_initialize()
	
	server = get_parent() as Server
	for key in clients:
		var value = clients[key]
		server.go_to_this_scene(key, "game_scene", {})
		server.update_clients_dic(key, clients)
		server.play_this_animation(key, "RESET", "Jouez !")
		server.play_this_hand_animation(key, clients)
		
	timer_start.start()
	
func _on_timer_start_timeout():
	for key in clients:
		server.play_this_animation(key, "in", "")
	timer_in.start()
	
func _on_timer_in_timeout():
	var	client_1 : Dictionary
	var client_2 : Dictionary
	
	var key1 : int
	var key2 : int
	
	var i : int = 0
	for key in clients:
		var value = clients[key]
		if i == 0:
			client_1 = value
			key1 = key
		if i == 1:
			client_2 = value
			key2 = key
		i += 1
	
	#winner = choice_point(client_1, client_2, key1, key2)
	if choice_point(client_1, client_2, key1, key2) != null:
		winner = choice_point(client_1, client_2, key1, key2)
	timer_hand.start()
	
	for key in clients:
		var s : String
		if str(key) == winner:
			s = "Vous avez gagnez"
		elif winner == "draw" :
			s = "Egalité"
		else :
			s = "Vous avez perdu"
		server.play_this_animation(key, "hand", "")
		server.play_this_hand_animation(key, clients)
	
	if(winner != "draw" && winner != null && winner != ""):
		if clients[int(winner)]["score"] + 1 < 3: 
			clients[int(winner)]["score"] += 1
		else:
			clients[int(winner)]["score"] += 1
			for key in clients:
				var value = clients[key]
				var args : Dictionary = {"winner_id":winner}
				server.go_to_this_scene(key, "winner_scene", args.duplicate())
			queue_free()
	#for key in clients:
		#server.play_this_hand_animation(key, clients)
			
	for key in clients:
		var value = clients[key]
		#clients[key]["client_choice"] = null
		
func _on_timer_hand_timeout():
	timer_end.start()
	var idle : Dictionary = clients.duplicate()
	for key in clients:
		idle = {key : {"client_choice":null}}
		
	for key in clients:
		server.play_hand_idle(key)
		
	for key in clients:
		var s : String
		if str(key) == winner:
			s = "Vous avez gagnez"
		elif winner == "draw" :
			s = "Egalité"
		else :
			s = "Vous avez perdu"
		server.play_this_animation(key, "end", s)
			
	for key in clients:
		#var value = clients[key]
		server.update_clients_dic(key, clients)
		clients[key]["client_choice"] = null
		
func _on_timer_end_timeout():
	for key in clients:
		server.play_this_animation(key, "RESET", "Play")
		server.play_hand_idle(key)
	timer_start.start()
	
func timer_initialize():
	timer_start = get_node("TimerStart") as Timer
	timer_start.one_shot = true
	timer_start.timeout.connect(_on_timer_start_timeout)
	
	timer_in = get_node("TimerIn") as Timer
	timer_in.one_shot = true
	timer_in.timeout.connect(_on_timer_in_timeout)
	
	timer_end = get_node("TimerEnd") as Timer
	timer_end.one_shot = true
	timer_end.timeout.connect(_on_timer_end_timeout)
	
	timer_hand = get_node("TimerHand") as Timer
	timer_hand.one_shot = true
	timer_hand.timeout.connect(_on_timer_hand_timeout)
	
func choice_point(p1, p2, k1, k2):
	p1 = p1["client_choice"]
	p2 = p2["client_choice"]
	
	if k1 == null || k2 == null:
		return ""
	
	if p1 == null && p2 != null:
		return str(k2)
	elif p2 == null && p1 != null:
		return str(k1)
	
	if p1 == null && p2 == null:
		server.go_to_this_scene(k1, "lobby_scene", {})
		server.go_to_this_scene(k2, "lobby_scene", {})
		queue_free()
		return
	
	if p1 == p2:
		return "draw"
	elif p1 == "rock" && p2 == "scissors" || p1 == "paper" && p2 == "rock" || p1 == "scissors" && p2 == "paper":
		return str(k1)
	else:
		return str(k2)
  RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name 	   _bundled    script       Script    res://Server/Game/Game.gd ��������      local://PackedScene_lnvdy          PackedScene          	         names "   	      Game    script    Node    TimerStart 
   wait_time    Timer    TimerIn 
   TimerHand 	   TimerEnd    	   variants                      �@     @@      @      node_count             nodes     -   ��������       ����                            ����                           ����                           ����                           ����                   conn_count              conns               node_paths              editable_instances              version             RSRC         extends Node
class_name Server

var network = ENetMultiplayerPeer.new()
var port
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
		instance_of_game_scene.clients = clients;
		add_child(instance_of_game_scene)
	
func StartServer() -> void:
	load_server_config()
	network.create_server(port, max_players);
	multiplayer.multiplayer_peer = network;
	print("server started");
	
	network.peer_connected.connect(_peer_connected);
	network.peer_disconnected.connect(_peer_disconnected);
	
func load_server_config()->void:
	var file = FileAccess.open("res://ServerConfig/Port.txt", FileAccess.READ)
	var content = file.get_as_text()
	port = int(content)

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
		
@rpc("call_remote")
func play_this_hand_animation(id : int, clients : Dictionary):
	if client_connected.has(id):
		print(clients)
		rpc_id(id, "play_this_hand_animation", clients)
		
@rpc("call_remote")
func play_hand_idle(id : int):
	if client_connected.has(id):
		rpc_id(id, "play_hand_idle")
		
@rpc("call_remote")
func go_to_this_scene(client_id : int, scene_name : String, args : Dictionary):
	if client_connected.has(client_id):
		if args != {}:
			print("winner")
		rpc_id(client_id, "go_to_this_scene", scene_name, args)
	
    RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name 	   _bundled    script       Script    res://Server/Main/Server.gd ��������      local://PackedScene_shhl6          PackedScene          	         names "         Server    script    Node    	   variants                       node_count             nodes     	   ��������       ����                    conn_count              conns               node_paths              editable_instances              version             RSRC           [remap]

importer="texture"
type="PlaceholderTexture2D"
uid="uid://by2x6um86u54i"
metadata={
"vram_texture": false
}
path="res://.godot/exported/950008424/export-218a8f2b3041327d8a5756f3a245f83b-icon.res"
   RSRC                    PlaceholderTexture2D            ��������                                                  resource_local_to_scene    resource_name    size    script        #   local://PlaceholderTexture2D_cj7hi �          PlaceholderTexture2D       
      C   C      RSRC         [remap]

path="res://.godot/exported/950008424/export-3ef6491e731a3e7a1986926f76805cfa-Game.scn"
               [remap]

path="res://.godot/exported/950008424/export-2681ef127eab13786f1a4502a39e9ef8-Server.scn"
             list=Array[Dictionary]([{
"base": &"GameModel",
"class": &"Game",
"icon": "",
"language": &"GDScript",
"path": "res://Server/Game/Game.gd"
}, {
"base": &"Node",
"class": &"GameModel",
"icon": "",
"language": &"GDScript",
"path": "res://Script/Server/Model/GameModel.gd"
}, {
"base": &"Node",
"class": &"Server",
"icon": "",
"language": &"GDScript",
"path": "res://Server/Main/Server.gd"
}])
         <svg height="128" width="128" xmlns="http://www.w3.org/2000/svg"><rect x="2" y="2" width="124" height="124" rx="14" fill="#363d52" stroke="#212532" stroke-width="4"/><g transform="scale(.101) translate(122 122)"><g fill="#fff"><path d="M105 673v33q407 354 814 0v-33z"/><path fill="#478cbf" d="m105 673 152 14q12 1 15 14l4 67 132 10 8-61q2-11 15-15h162q13 4 15 15l8 61 132-10 4-67q3-13 15-14l152-14V427q30-39 56-81-35-59-83-108-43 20-82 47-40-37-88-64 7-51 8-102-59-28-123-42-26 43-46 89-49-7-98 0-20-46-46-89-64 14-123 42 1 51 8 102-48 27-88 64-39-27-82-47-48 49-83 108 26 42 56 81zm0 33v39c0 276 813 276 813 0v-39l-134 12-5 69q-2 10-14 13l-162 11q-12 0-16-11l-10-65H447l-10 65q-4 11-16 11l-162-11q-12-3-14-13l-5-69z"/><path d="M483 600c3 34 55 34 58 0v-86c-3-34-55-34-58 0z"/><circle cx="725" cy="526" r="90"/><circle cx="299" cy="526" r="90"/></g><g fill="#414042"><circle cx="307" cy="532" r="60"/><circle cx="717" cy="532" r="60"/></g></g></svg>
             ����!�@   res://Server/Game/Game.tscn&X2zD�s   res://Server/Main/Server.tscn
,��$J9   res://icon.svg  ECFG      _custom_features         dedicated_server   application/config/name         ShiFuMiServerSide      application/run/main_scene(         res://Server/Main/Server.tscn      application/config/features$   "         4.2    Forward Plus       application/config/icon         res://icon.svg       