extends CharacterBody2D
class_name Enemy
@export var stats : EnemyResource
@export var panel : Panel
@export var animation : AnimationPlayer
@export var health : HealthComponent
@export var target : Node2D
@export var nav : NavigationAgent2D
@export var path_num : int = 1
var shader : Shader = preload("uid://chudojcwfpmos").duplicate()
var panel_texture = StyleBoxFlat.new()
var speed

signal killed

func _ready() -> void:
	if target:
		nav.target_position = target.global_position
	else:
		print("no target")
	if nav.avoidance_enabled:
		nav.velocity_computed.connect(on_velocity_computed)
	nav.set_navigation_layer_value(1,false)
	nav.set_navigation_layer_value(path_num,true)
	speed = stats.speed
	
	health.max_health = stats.health
	health.health = stats.health
	health.death.connect(die)
	
	panel.material = panel.material.duplicate(true)
	panel.material.set_shader_parameter("edges",stats.sides)
	panel_texture.bg_color = stats.color
	panel.add_theme_stylebox_override("panel",panel_texture)
	
	animation.play(stats.animations["walk"])
	
	health.damaged.connect(damage)

func _physics_process(_delta: float) -> void:
	var next_position = nav.get_next_path_position()
	var new_velocity = global_position.direction_to(next_position) * speed
	if nav.avoidance_enabled:
		nav.set_velocity(new_velocity)
	else:
		on_velocity_computed(new_velocity)
	move_and_slide()

func on_velocity_computed(safe_elocity):
	velocity = safe_elocity

func die():
	killed.emit(self)
	await get_tree().physics_frame
	queue_free()

func damage():
	pass
