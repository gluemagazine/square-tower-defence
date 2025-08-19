extends CanvasLayer
class_name BuildInterface

@export var parent : Node2D
@export var empty_slot : Control
@export var container : HBoxContainer

var towers :
	get:
		if parent:
			return parent.valid_towers
		else:
			return null

func _ready() -> void:
	Game.tower_opened.connect(check)
	for key in towers:
		var instance = TowerIcon.new()
		instance.tower = towers[key]
		container.add_child(instance)

func open():
	empty_slot.show()
	show()

func close():
	empty_slot.hide()
	hide()

func select():
	Game.tower_opened.emit(self)

func check(tower):
	if tower == self:
		open()
	else:
		close()
