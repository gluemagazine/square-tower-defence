extends CharacterBody2D
class_name Shot

@export var damage:int = 1
@export var sight:Area2D
@export var target:String = "enemy"
@export var acceleration:float = 2200
@export var speed:float = 300
@export var drag:float = 1500

var direction:Vector2 = Vector2.ZERO

func _ready() -> void:
	if sight:
		sight.area_entered.connect(on_area_entered)

func _physics_process(delta: float) -> void:
	if velocity.length() <= 10:
		velocity = Vector2.ZERO
	else:
		velocity -= velocity.normalized()*drag*delta
	if velocity.length()<speed:
		velocity += direction.normalized()*(acceleration+drag)*delta
	move_and_slide()
	

func on_area_entered(body:Node)->void:
	if body is HitboxComponent:
		if body.holder.is_in_group("enemy"):
			var attak:Attack = Attack.new()
			attak.damage = damage
			body.damage(attak)
			velocity = Vector2.ZERO
			extra()

func extra()->void:
	pass
