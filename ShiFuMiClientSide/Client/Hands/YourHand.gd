extends Hand
class_name YourHand

func _on_play_this_hand_animation(clients : Dictionary):
	var my_id = Server.get_id()
	
	var my_choice = clients[my_id]["client_choice"]
	
	if my_choice != null:
		animation_player.play(my_choice)
	else :
		animation_player.play("idle")
