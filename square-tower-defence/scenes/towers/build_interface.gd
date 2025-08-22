extends CanvasLayer
class_name BuildInterface

@export var parent : TowerSlot
@export var empty_slot : Control
@export var container : HBoxContainer
@export var icon : PackedScene

@onready var upgrade: Button = %upgrade

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

func manual_close():
	hide()
	Game.tower_open = false

func select():
	Game.tower_open = false
	Game.tower_opened.emit(self)

func check(tower):
	if tower == self:
		open()
	else:
		close()

func click_tower(tower : TowerResource):
	if Game.gold >= tower.initial_cost:
		parent.build_tower(tower)
		if tower.upgrades != []:
			upgrade.tooltip_text = tower.upgrades[0].description
		Game.subtract_gold(tower.initial_cost)
