extends Control
class_name TowerIcon

@export var tower : TowerResource = preload("uid://cadpa641en0h4")
var panels : Array[AnimatedPanel] = []

func _ready() -> void:
	for panel in tower.panels:
		var instance = AnimatedPanel.new()
		instance.setup_from_container(panel)
		instance.position = -panel.dimentions / 2
		add_child(instance)
		panels.append(instance)
		instance.stop()
		instance.scale = Vector2(2,2)
	custom_minimum_size = Vector2(100,0)

func play():
	for panel in panels:
		panel.play_animation("fire")
