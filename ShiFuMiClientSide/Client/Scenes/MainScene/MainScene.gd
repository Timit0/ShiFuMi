extends Scene; 
class_name MainScene;

var lobby_scene = preload("res://Client/Scenes/Lobby/Lobby.tscn").instantiate()
var game_scene = preload("res://Client/Scenes/Game/Game.tscn").instantiate()
var winner_scene = preload("res://Client/Scenes/Winner/Winner.tscn").instantiate()
	
func _ready():
	add_child(lobby_scene)
	Server.change_to_this_scene_signal.connect(_on_change_to_this_scene_signal)
	Server.change_to_winner_scene_signal.connect(_on_change_to_winner_scene_signal)

func _on_change_to_this_scene_signal(scene_name : String):
	for child in get_children():
		remove_child(child)
	
	if scene_name == "game_scene":
		add_child(game_scene)
	if scene_name == "lobby_scene":
		add_child(lobby_scene)

func _on_change_to_winner_scene_signal(winner_id : int):
	for child in get_children():
		remove_child(child)
		winner_scene = winner_scene as WinnerScene
		winner_scene.winner = winner_id
		add_child(winner_scene)
