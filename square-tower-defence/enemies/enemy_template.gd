extends CharacterBody2D
@export var stats : EnemyResource
@export var panel : Panel
@export var animation : AnimationPlayer
@export var health : HealthComponent
var shader : Shader = preload("uid://chudojcwfpmos").duplicate()
var speed

func _ready() -> void:
	speed = stats.speed
	
	health.max_health = stats.health
	health.health = stats.health
	
	panel.material = panel.material.duplicate(true)
	panel.material.set_shader_parameter("edges",stats.sides)
	
	animation.play(stats.animations["walk"])
	
