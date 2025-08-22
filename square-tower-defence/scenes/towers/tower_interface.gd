extends CanvasLayer
class_name TowerInterface

@export var parent : TowerSlot

func _ready() -> void:
	Game.tower_opened.connect(check)

func build():
	pass

func open():
	Game.tower_open = true
	show()

func close():
	hide()

func manual_close():
	hide()
	Game.tower_open = false

func select():
	Game.tower_opened.emit(self)

func check(tower):
	if tower == self:
		open()
	else:
		close()
