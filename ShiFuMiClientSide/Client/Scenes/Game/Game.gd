extends Node2D
class_name Game

var otherName : Label
var otherScore : Label
var myScore : Label

func _ready():
	otherName = get_node("%OtherName")
	otherScore = get_node("%OtherScore")
	myScore = get_node("%MyScore")
	

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


func _on_rock_pressed():
	Server.send_choice_from_client_to_serv("rock")


func _on_paper_pressed():
	Server.send_choice_from_client_to_serv("paper")


func _on_scissors_pressed():
	Server.send_choice_from_client_to_serv("scissors")
