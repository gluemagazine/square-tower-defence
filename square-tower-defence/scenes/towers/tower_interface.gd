extends CanvasLayer
class_name TowerInterface

@export var parent : TowerSlot

var delay : bool = true

func _ready() -> void:
	Game.tower_opened.connect(check)

func build():
	pass

func open():
	Game.tower_open = true
	show()
	await  get_tree().physics_frame
	delay = false

func close():
	hide()
	delay = true

func manual_close():
	hide()
	Game.tower_open = false
	delay = true

func select():
	Game.tower_opened.emit(self)

func check(tower):
	if tower == self:
		open()
	else:
		close()

func _unhandled_input(event: InputEvent) -> void:
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if delay:
				return
			if visible:
				close()
