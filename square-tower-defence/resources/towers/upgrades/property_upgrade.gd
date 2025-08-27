extends Resource
class_name PropertyUpgrade


@export var cooldown : bool = false
@export_enum("velocity","damage","freeze_duration","explosion_radius",
"explosion_damage","explosion_freeze_duration","homing","set_target"
,"explode","damage_one","bullet_size") 
var property : String = "damage"

@export_enum("add","multiply","divide","set") var increase_type : String = "add"

@export var modify_value : float = 1.0


func apply(tower : TowerResource):
	if cooldown:
		match increase_type:
			"add":
				tower.cooldown += modify_value
			"multiply":
				tower.cooldown *= modify_value
			"divide":
				tower.cooldown /= modify_value
			"set":
				tower.cooldown = modify_value
	else:
		match increase_type:
			"add":
				tower.bullet_stats[property] += modify_value
			"multiply":
				tower.bullet_stats[property] *= modify_value
			"divide":
				tower.bullet_stats[property] /= modify_value
			"set":
				tower.bullet_stats[property] = modify_value
