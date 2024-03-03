extends GameModel
class_name Game

var server

func _ready():
	server = get_parent() as Server
	print(clients)
	for key in clients:
		var value = clients[key]
		server.go_to_game_scene(key)
		server.update_clients_dic(key, clients)
