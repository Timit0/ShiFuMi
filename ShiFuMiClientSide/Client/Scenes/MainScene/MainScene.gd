extends Scene; 
class_name MainScene;

var lobby_scene = preload("res://Client/Scenes/Lobby/Lobby.tscn").instantiate()
var game_scene = preload("res://Client/Scenes/Game/Game.tscn").instantiate()
	
func _ready():
	add_child(lobby_scene)
	
	Server.change_to_this_scene_signal.connect(_on_change_to_this_scene_signal)


func _on_change_to_this_scene_signal():
	print("signal is called")
	for child in get_children():
		remove_child(child)
		
	add_child(game_scene)
