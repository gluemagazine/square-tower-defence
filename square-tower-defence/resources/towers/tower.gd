extends Resource
class_name TowerResource

@export var tower_name : String = "Archer"

@export var sides : int = 3
@export var color : Color = Color.GREEN
@export var panels : Array[PanelAnimationContainer]
@export var cooldown : float = 2
@export var range_radius : int = 50
@export var bullet_scene : PackedScene = preload("uid://d2xoy8bd7beyr")

@export var bullet_stats: Dictionary[String,Variant] = {
	"velocity" = 300,
	"bullet_size" = Vector2(10,10),
	"bullet_color" = Color.GREEN,
	"damage_one" = true,
	"damage" = 1,
	"explode" = false,
	"explosion_radius" = 15,
	"explosion_damage" = 1,
	"explosion_color" = Color.RED,
	"freeze" = false,
	"set_target" = false,
	"homing" = false,
}
