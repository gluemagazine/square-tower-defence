extends Node2D
class_name ArcherTower

#just me messign around
@export var stats : TowerResource
@export var sightComp:SightComponent
@onready var cool_down: Timer = $coolDown

var panels : Array[AnimatedPanel]

var modular_bullet = preload("uid://ig5c4t7spifk")
var locked = false

func _ready() -> void:
	cool_down.timeout.connect(unlock)
	cool_down.wait_time = stats.cooldown
	
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
		for panel in panels:
			panel.play_animation("fire")
		cool_down.start()
		lock()

func lock():
	locked = true
func unlock():
	locked = false
