extends Scene; 
class_name MainScene;

var lobby_scene = preload("res://Client/Scenes/Lobby/Lobby.tscn").instantiate() as Lobby
var game_scene = preload("res://Client/Scenes/Game/Game.tscn").instantiate() as Game
var winner_scene = preload("res://Client/Scenes/Winner/Winner.tscn").instantiate() as WinnerScene

var scene_node : Node
	
func _ready():
	scene_node = get_node("Scene") as Node
	scene_node.add_child(lobby_scene)
	#
	Server.change_to_this_scene_signal.connect(_on_change_to_this_scene)

func _on_change_to_this_scene(scene_name : String, args : Dictionary):
	print(scene_name)
	for child in scene_node.get_children():
		scene_node.remove_child(child)
		if scene_name == "game_scene":
			game_scene.current_choice = 3
			scene_node.add_child(game_scene)
		if scene_name == "lobby_scene":
			scene_node.add_child(lobby_scene)
		if scene_name == "winner_scene":
			winner_scene.winner = args["winner_id"]
			scene_node.add_child(winner_scene)
