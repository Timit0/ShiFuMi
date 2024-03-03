extends Scene
class_name Lobby

func _on_button_play_pressed():
	Server.add_in_queue_signal.emit()
