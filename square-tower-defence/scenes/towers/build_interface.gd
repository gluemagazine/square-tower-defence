extends CanvasLayer
class_name BuildInterface

@export var parent : Node2D
@export var empty_slot : Control
@export var container : HBoxContainer
@export var icon : PackedScene

var towers :
	get:
		if parent:
			return parent.valid_towers
		else:
			return null

func _ready() -> void:
	Game.tower_opened.connect(check)
	for key in towers:
		var instance : TowerIcon = icon.instantiate()
		instance.tower = towers[key]
		container.add_child(instance)
		instance.selected.connect(click_tower)

func open():
	show()
	Game.tower_open = true

func close():
	hide()

func select():
	Game.tower_open = false
	Game.tower_opened.emit(self)

func check(tower):
	if tower == self:
		open()
	else:
		close()

func click_tower(tower):
	parent.build_tower(tower)
