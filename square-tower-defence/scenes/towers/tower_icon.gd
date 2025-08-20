extends Control
class_name TowerIcon

@export var tower : TowerResource = preload("uid://cadpa641en0h4")
var panels : Array[AnimatedPanel] = []

signal selected

@export var button : Button
@export var label : Label

func _ready() -> void:
	for panel in tower.panels:
		var instance = AnimatedPanel.new()
		instance.setup_from_container(panel)
		instance.position = -panel.dimentions / 2
		add_child(instance)
		panels.append(instance)
		instance.stop()
		instance.scale = Vector2(2,2)
	await get_tree().physics_frame
	custom_minimum_size = Vector2(100,0)
	button.custom_minimum_size = custom_minimum_size
	move_child(button,-1)
	label.text = str(tower.initial_cost)


func play():
	for panel in panels:
		panel.play_animation("fire")

func select():
	selected.emit(tower)
