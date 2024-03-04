extends GameModel
class_name Game

var server

var timer

func _ready():
	timer_initialize()
	server = get_parent() as Server
	print(clients)
	for key in clients:
		var value = clients[key]
		server.go_to_game_scene(key)
		server.update_clients_dic(key, clients)
		
	timer.start()
	
func _on_timer_timeout():
	timer.start()
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
		
	var winner = choice_point(client_1, client_2, key1, key2)
	if(winner != "draw"):
		if clients[int(winner)]["score"] + 1 < 3: 
			clients[int(winner)]["score"] += 1
		else:
			clients[int(winner)]["score"] += 1
			print("change")
			for key in clients:
				var value = clients[key]
				server.go_to_game_winner(key, int(winner))
			queue_free()
			
	for key in clients:
		var value = clients[key]
		server.update_clients_dic(key, clients)
		clients[key]["client_choice"] = null
	
func timer_initialize():
	timer = get_node("Timer") as Timer
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	
func choice_point(p1, p2, k1, k2):
	p1 = p1["client_choice"]
	p2 = p2["client_choice"]
	
	if p1 == null && p2 != null:
		return str(k2)
	else:
		return str(k1)
	
	if p1 == p2:
		return "draw"
	elif p1 == "rock" && p2 == "scissors" || p1 == "paper" && p2 == "rock" || p1 == "scissors" && p2 == "paper":
		return str(k1)
	else:
		return str(k2)


