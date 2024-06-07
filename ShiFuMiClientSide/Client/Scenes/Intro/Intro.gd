extends Node

func _ready():
	$AnimationPlayer.play("RESET")

func _on_animation_player_animation_finished(anim_name):
	get_tree().change_scene_to_file("res://Client/Scenes/MainScene/MainScene.tscn")
