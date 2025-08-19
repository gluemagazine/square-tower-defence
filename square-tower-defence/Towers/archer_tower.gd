extends Node2D
class_name TowerTemplate

#just me messign around
@export var stats : TowerResource
@export var sightComp:SightComponent
@export var range : CollisionShape2D
@export var range_visual : Panel
@onready var cool_down: Timer = $coolDown

var panels : Array[AnimatedPanel]

var modular_bullet = preload("uid://ig5c4t7spifk")
var locked = false

signal selected

func _ready() -> void:
	cool_down.timeout.connect(unlock)
	cool_down.wait_time = stats.cooldown
	range.shape.radius = stats.range_radius
	var radius = stats.range_radius
	range_visual.size = Vector2(radius,radius)
	range_visual.position = Vector2(-radius,-radius)
	
	for panel in stats.panels:
		var instance = AnimatedPanel.new()
		instance.setup_from_container(panel)
		add_child(instance)
		instance.position = - panel.dimentions / 2
		panels.append(instance)
		instance.stop()
	$baseTexture.hide()

func _physics_process(delta: float) -> void:
	if locked:
		return
	if sightComp.target:
		var shot : Bullet = modular_bullet.instantiate()
		shot.build_params = stats.bullet_stats
		get_tree().current_scene.add_child(shot)
		shot.global_position = global_position
		shot.dir = (sightComp.target.global_position-global_position).normalized()
		if stats.bullet_stats["set_target"]:
			shot.set_target = sightComp.target
		for panel in panels:
			panel.play_animation("fire")
		cool_down.start()
		lock()

func upgrade():
	for panel in panels:
		panel.level_up()

func lock():
	locked = true
func unlock():
	locked = false


func _on_button_pressed() -> void:
	selected.emit()
