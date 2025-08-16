extends CharacterBody2D
class_name Enemy
@export var stats : EnemyResource
var panels : Array[AnimatedPanel]

@export var health : HealthComponent
@export var target : Node2D
@export var nav : NavigationAgent2D
@export var path_num : int = 1
var shader : Shader = preload("uid://chudojcwfpmos").duplicate()
var panel_texture = StyleBoxFlat.new()
var speed
var distance = 0

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
	health.damaged.connect(damage)
	for key in stats.panels:
		var panel = AnimatedPanel.new()
		var params = stats.panels[key]
		panel.setup_from_container(params)
		add_child(panel)
		panel.position = -params.dimentions / 2
		panels.append(panel)
	for panel in panels:
		panel.stop()
		panel.play_index(0)
	await get_tree().physics_frame
	nav.get_next_path_position()
	var points = nav.get_current_navigation_path()
	points.insert(0,global_position)
	for i in range(points.size() - 1):
		distance += points[i].distance_to(points[i+1])

func _physics_process(delta: float) -> void:
	var next_position = nav.get_next_path_position()
	var new_velocity = global_position.direction_to(next_position) * speed
	if nav.avoidance_enabled:
		nav.set_velocity(new_velocity)
	else:
		on_velocity_computed(new_velocity)
	distance -= velocity.length() * delta
	move_and_slide()

func on_velocity_computed(safe_elocity):
	velocity = safe_elocity

func die():
	killed.emit(self)
	Game.add_gold(stats.reward)
	await get_tree().physics_frame
	queue_free()

func damage():
	for panel in panels:
		panel.play_on_top("hurt")

func _exit_tree() -> void:
	Game.enemy_killed.emit()
