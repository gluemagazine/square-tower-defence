extends Node2D
class_name ManualSpawner

@export var path_num : int 
@export var new_parent : Node
@export var target : Node2D
var enemy_scene = preload("uid://biekub6ra6v5j")

func spawn(enemy : EnemyResource):
	var instance = enemy_scene.instantiate()
	instance.stats = enemy
	instance.global_position = global_position
	instance.target = target
	instance.path_num = path_num
	if new_parent:
		new_parent.add_child(instance)
	else:
		get_parent().add_child(instance)
	return instance
