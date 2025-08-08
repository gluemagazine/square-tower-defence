extends CharacterBody2D
@export var stats : EnemyResource
@export var panel : Panel
@export var animation : AnimationPlayer
@export var health : HealthComponent
@export var target : Marker2D
@export var nav : NavigationAgent2D
@export var path_num : int = 1
var shader : Shader = preload("uid://chudojcwfpmos").duplicate()
var speed

func _ready() -> void:
	if target:
		nav.target_position = target.global_position
	else:
		print("no target")
	nav.set_navigation_layer_value(1,false)
	nav.set_navigation_layer_value(pow(2,path_num-1),true)
	speed = stats.speed
	
	health.max_health = stats.health
	health.health = stats.health
	
	panel.material = panel.material.duplicate(true)
	panel.material.set_shader_parameter("edges",stats.sides)
	
	animation.play(stats.animations["walk"])

func _physics_process(delta: float) -> void:
	nav.get_next_path_position()
