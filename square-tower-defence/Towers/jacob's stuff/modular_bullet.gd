extends Area2D
class_name Bullet


@export var damage : int = 1
@export var velocity : int = 300
@export var dir : Vector2 = Vector2(1,0):
	set(new):
		dir = new
		global_rotation = dir.angle() + PI / 2
		

@export var build_params : Dictionary[String,Variant] ={
	"velocity" = 300,
	"bullet_size" = Vector2(10,10),
	"bullet_color" = Color.GREEN,
	"damage_one" = true,
	"damage" = 1,
	"explode" = false,
	"explosion_radius" = 15,
	"explosion_damage" = 1,
	"explosion_color" = Color.RED,
	"homing" = false
}

var child_effects : Dictionary[String,Node2D]

var effects : Array[Callable]
var used = false

var visual

func _ready():
	area_entered.connect(check)
	$CollisionShape2D.shape.radius = min(build_params["bullet_size"].x,build_params["bullet_size"].y)/2
	velocity = build_params["velocity"]
	visual = QOL.create_panel_with_shader(50,build_params["bullet_color"])
	visual.size = build_params["bullet_size"]
	visual.position = -build_params["bullet_size"] / 2
	add_child(visual)
	
	damage = build_params["damage"]
	if build_params["damage_one"]:
		effects.append(attack_single.bind())
	
	if build_params["explode"]:
		var explosion = Explosion.new()
		explosion.set_params_from_dictionary(build_params)
		add_child(explosion)
		explosion.exploded.connect(explode)
		explosion.finished.connect(expire)
		effects.append(explode.bind())
		effects.append(explosion.explode.bind())

func _physics_process(delta: float) -> void:
	position += velocity * dir * delta

var wait = false

func check(area : Area2D):
	if area is HitboxComponent:
		hit()
		return

func hit():
	if used: return
	used = true
	for effect in effects:
		effect.call()
	if not wait:
		expire()

func expire():
	queue_free()

func explode():
	wait = true
	visual.hide()
	velocity = 0

func attack_single():
	for area in get_overlapping_areas():
		if area is HitboxComponent:
			var attack = QOL.generate_attack(damage)
			area.damage(attack)
			return
