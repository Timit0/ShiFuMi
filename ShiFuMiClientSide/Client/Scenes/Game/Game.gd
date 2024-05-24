extends Node2D
class_name Game

var otherName : Label
var otherScore : Label
var myScore : Label

enum CHOICE
{
	ROCK,
	PAPER,
	SCISSORS,
	NULL
}

var current_choice : CHOICE = CHOICE.NULL

func _ready():
	otherName = get_node("%OtherName") as Label
	otherScore = get_node("%OtherScore") as Label
	myScore = get_node("%MyScore") as Label
	
	Server.play_this_animation_signal.connect(_on_play_this_animation)
	$AnimationPlayer.play("RESET")

func _process(delta):
	update_info()
	
func update_info():
	for key in Server.clients:
		var value = Server.clients[key]
		if(key != Server.get_id()):
			otherName.text = str(key)
			otherScore.text = str(value["score"])
		else :
			myScore.text = str(value["score"])

func _on_play_this_animation(animation_name : String, state_label : String):
	(get_node("Animation/AnimationPlayer") as AnimationPlayer).play(animation_name)
	if state_label != "":
		(get_node("Animation/CenterContainer/State") as Label).text = state_label

func _on_rock_pressed():
	Server.send_choice_from_client_to_serv("rock")
	current_choice = CHOICE.ROCK
	
func _on_paper_pressed():
	Server.send_choice_from_client_to_serv("paper")
	current_choice = CHOICE.PAPER
	
func _on_scissors_pressed():
	Server.send_choice_from_client_to_serv("scissors")
	current_choice = CHOICE.SCISSORS
	
func current_choice_to_null():
	current_choice = CHOICE.NULL
