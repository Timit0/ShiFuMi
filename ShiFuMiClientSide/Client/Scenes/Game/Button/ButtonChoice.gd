extends Button
class_name ButtonChoice

enum CHOICE
{
	ROCK,
	PAPER,
	SCISSORS
}

@export
var returned_val : CHOICE

var parent : Game

func _ready():
	parent = get_node("../../../../") as Game
	
func _process(delta):
	if parent.current_choice == returned_val:
		modulate = Color.AQUA
	else:
		modulate = Color.WHITE
