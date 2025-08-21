extends Resource
class_name TowerResource

@export var tower_name : String = "Archer"

@export var initial_cost : int = 100
@export var panels : Array[PanelAnimationContainer]
@export var cooldown : float = 2
@export var range_radius : int = 50
@export var bullet_scene : PackedScene = preload("uid://d2xoy8bd7beyr")


func true_duplicate():
	var dupe : Dictionary[String,Variant] = {}
	for key in bullet_stats:
		dupe[key] = bullet_stats[key]
	bullet_stats = dupe
	

@export var bullet_stats: Dictionary[String,Variant] = {
	"velocity" = 300,
	"bullet_size" = Vector2(10,10),
	"bullet_color" = Color.GREEN,
	"damage_one" = true,
	"damage" = 1,
	"freeze" = false,
	"freeze_duration" = 1.0,
	"explode" = false,
	"explosion_radius" = 15,
	"explosion_damage" = 1,
	"explosion_color" = Color.RED,
	"explosion_freeze" = false,
	"explosion_freeze_duration" = 1.0,
	"set_target" = false,
	"homing" = false,
}
