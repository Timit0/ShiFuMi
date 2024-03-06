extends Hand
class_name OtherHand

func _on_play_this_hand_animation(clients : Dictionary):
	var other
	for key in clients:
		if Server.get_id() != key:
			other = key
	
	var other_choice = clients[other]["client_choice"]
	
	
	
	if other_choice != null:
		animation_player.play(other_choice)
		label.text = other_choice
	else :
		animation_player.play("idle")
