extends Node2D
class_name TowerSlot

var current_tower : TowerTemplate:
	set(new):
		current_tower = new
		if tower_interface:
			tower_interface.build()

var tower : TowerResource:
	get:
		if not current_tower: return null
		return current_tower.stats

var tower_scene = preload("uid://downv7grip0yk")

@export var empty_slot : Control
@export var build_interface : BuildInterface
@export var tower_interface : TowerInterface

@onready var upgrade: Button = %upgrade

static var valid_towers : Dictionary[String,TowerResource] = {
	"archer" : preload("uid://cadpa641en0h4"),
	"bomber" : preload("uid://ckx4xbo8ucm17"),
	"ice" : preload("uid://d3lbiruxcdvek"),
	"sniper" : preload("uid://d2jsim4qx5b0e"),
	"machine_gun" : preload("uid://d2ngv4oh4pite"),
	"greg" : preload("uid://bfqx0m0oevjtr"),
}

func build_tower(tower):
	var instance : TowerTemplate = tower_scene.instantiate()
	instance.stats = tower.duplicate(true)
	current_tower = instance
	instance.selected.connect(tower_interface.select)
	add_child(instance)
	empty_slot.hide()
	tower_interface.select()
	if tower.level >= tower.upgrades.size():
		upgrade.disabled = true
		upgrade.tooltip_text = "Max Level"


func _on_upgrade_pressed() -> void:
	if current_tower:
		current_tower.upgrade()
		if not tower.level >= tower.upgrades.size():
			upgrade.tooltip_text = tower.upgrades[tower.level].description
		else:
			upgrade.disabled = true
			upgrade.tooltip_text = "Max Level"

func _on_sell_pressed() -> void:
	if current_tower:
		Game.add_gold(current_tower.stats.initial_cost)
		current_tower.queue_free()
		current_tower = null
		empty_slot.show()
		tower_interface.close()
		upgrade.disabled = false
