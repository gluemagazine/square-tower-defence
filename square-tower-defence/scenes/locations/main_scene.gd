extends Node2D

@export var default_scene : PackedScene
@export var default_path : String

var current_scene

func _ready() -> void:
	if default_scene:
		load_scene(default_scene)
	else:
		load_level(default_path)

func unload_level():
	if is_instance_valid(current_scene):
		current_scene.queue_free()
		current_scene = null

func load_level(scene_name):
	var resource_path = "res://scenes/locations/levels/%s.tscn" %scene_name
	var level_resource = load(resource_path)
	if level_resource:
		load_scene(level_resource)

func load_scene(packed : PackedScene):
	unload_level()
	var instance = packed.instantiate()
	add_child(instance)
	current_scene = instance
