extends Node2D
class_name TowerSlot

var current_tower : TowerTemplate:
	set(new):
		current_tower = new
		if tower_interface:
			tower_interface.build()

var tower_scene = preload("uid://downv7grip0yk")

@export var build_interface : BuildInterface
@export var tower_interface : TowerInteface

static var valid_towers : Dictionary[String,TowerResource] = {
	"archer" : preload("uid://cadpa641en0h4"),
	"bomber" : preload("uid://cadpa641en0h4"),
	"ice" : preload("uid://cadpa641en0h4"),
	"sniper" : preload("uid://cadpa641en0h4"),
	"machine_gun" : preload("uid://cadpa641en0h4"),
}

func build_tower(tower):
	var instance : TowerTemplate = tower_scene.instantiate()
	instance.stats = tower
	current_tower = instance
	instance.selected.connect(tower_interface.build)
