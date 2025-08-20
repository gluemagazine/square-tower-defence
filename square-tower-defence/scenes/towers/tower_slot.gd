extends Node2D
class_name TowerSlot

var current_tower : TowerTemplate:
	set(new):
		current_tower = new
		if tower_interface:
			tower_interface.build()

var tower_scene = preload("uid://downv7grip0yk")

@export var empty_slot : Control
@export var build_interface : BuildInterface
@export var tower_interface : TowerInterface

static var valid_towers : Dictionary[String,TowerResource] = {
	"archer" : preload("uid://cadpa641en0h4"),
	"bomber" : preload("uid://d3lbiruxcdvek"),
	"ice" : preload("uid://ckx4xbo8ucm17"),
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


func _on_upgrade_pressed() -> void:
	if current_tower:
		current_tower.upgrade()


func _on_sell_pressed() -> void:
	if current_tower:
		Game.add_gold(current_tower.stats.initial_cost)
		current_tower.queue_free()
		current_tower = null
		empty_slot.show()
		tower_interface.close()
