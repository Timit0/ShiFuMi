extends Node2D
class_name Hand

var animation_player : AnimationPlayer

@export
var am_i_other : bool

var label : Label

func _ready():
	label = get_node("Label")
	animation_player = get_node("AnimationPlayer") as AnimationPlayer
	Server.play_this_hand_animation_signal.connect(_on_play_this_hand_animation)
	
func _on_play_this_hand_animation(clients : Dictionary):
	var iam = Server.get_id()
	var not_me : int
	for key in clients:
		if key != iam:
			not_me = key
	if name.contains("other"):
		if clients[not_me]["client_choice"] != null:
			animation_player.play(clients[not_me]["client_choice"])
		else:
			animation_player.play("idle")
	else:
		if clients[iam]["client_choice"] != null:
			animation_player.play(clients[iam]["client_choice"])
		else:
			animation_player.play("idle")
