extends Node2D
class_name WinnerScene

var winner : int

var winner_label : Label

func _ready():
	winner_label = get_node("CenterContainer/WinnerLabel") as Label
	winner_label.text = str(winner) 



func _on_lobby_button_pressed():
	Server.change_to_this_scene_signal.emit("lobby_scene")
