extends Node2D

func _ready() -> void:
	get_child(0).play_animation("walk")
