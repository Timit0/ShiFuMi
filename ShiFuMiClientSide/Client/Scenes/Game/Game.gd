extends Node2D
class_name Game

var other : Label

func _ready():
	other = get_node("%Other")

func _process(delta):
	update_info()
	
func update_info():
	for key in Server.clients:
		if(key != Server.get_id()):
			other.text = str(key)
