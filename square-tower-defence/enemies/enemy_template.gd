extends CharacterBody2D
@export var stats : EnemyResource
@export var panel : Panel
@export var animation : AnimationPlayer
var shader : Shader = preload("uid://chudojcwfpmos").duplicate()


func _ready() -> void:
	panel.material = panel.material.duplicate(true)
	panel.material.set_shader_parameter("edges",stats.sides)
	
