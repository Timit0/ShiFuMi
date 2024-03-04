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
	print("-----------------------------------------------------------------------------")
	print(clients)
	print("-----------------------------------------------------------------------------")
	for key in clients:
		var value = clients[key]
		print(key)
	
func timer_initialize():
	timer = get_node("Timer") as Timer
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
