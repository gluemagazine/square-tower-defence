extends Upgrade
class_name OverrideUpgrade

@export var override : Dictionary[String,Variant] = {
	"velocity" = 300,
	"bullet_size" = Vector2(10,10),
	"bullet_color" = Color.GREEN,
	"damage_one" = true,
	"damage" = 1,
	"freeze_duration" = 0.0,
	"explode" = false,
	"explosion_radius" = 15,
	"explosion_damage" = 1,
	"explosion_color" = Color.RED,
	"explosion_freeze_duration" = 0.0,
	"set_target" = false,
	"homing" = false,
}

func apply(tower):
	super(tower)
	tower.bullet_stats = override
