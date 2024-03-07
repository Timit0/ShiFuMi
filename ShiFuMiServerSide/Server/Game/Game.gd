extends GameModel
class_name Game

var server : Server

var timer_in : Timer
var timer_start : Timer
var timer_end : Timer
var timer_hand : Timer

var winner : String

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
	
	if(winner != "draw" && winner != null):
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
