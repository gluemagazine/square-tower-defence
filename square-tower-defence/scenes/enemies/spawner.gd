extends Node2D
class_name StaticSpawner
@export var enemy : EnemyResource
@export var interval : float = 1.0
var enemy_scene = preload("uid://biekub6ra6v5j")

func spawn():
	var instance = enemy_scene.instantiate()
	instance.stats = enemy
	instance.global_position = global_position
	get_parent().add_child(instance)
	await  get_tree().create_timer(interval)
	spawn()
