extends Area2D
class_name Bullet


@export var damage : int = 1
@export var velocity : int = 300
@export var dir : Vector2 = Vector2(1,0):
	set(new):
		dir = new
		global_rotation = dir.angle() + PI / 2
@export var set_target : Node2D = null
@export var parent_object : TowerTemplate

var distance_to_parent:
	get: return global_position.distance_to(parent_object.global_position)

var parent_range : 
	get : return parent_object.stats.range_radius

func set_new_target(new):
	if is_instance_valid(set_target):
		return
	if distance_to_parent >= parent_range:
		return
	set_target = new

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
	"freeze" = false,
	"freeze_duration" = 1.0,
	"set_target" = false,
	"homing" = false,
}

var child_effects : Dictionary[String,Node2D]

var effects : Array[Callable]
var used = false

var visual

var freeze_duration = 0.0

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
	
	if build_params.has("freeze_duration"):
		freeze_duration = build_params["freeze_duration"]

func _physics_process(delta: float) -> void:
	position += velocity * dir * delta
	if build_params["homing"]:
		if set_target:
			dir = (set_target.global_position - global_position).normalized()

var wait = false

func check(area : Area2D):
	if area is HitboxComponent:
		if set_target:
			if not is_instance_valid(set_target):
				set_target = null
				hit()
			elif area.get_parent() == set_target:
				hit()
		else:
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
			var attack = QOL.generate_attack(damage,freeze_duration)
			area.damage(attack)
			return
