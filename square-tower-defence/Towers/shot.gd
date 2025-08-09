extends CharacterBody2D
class_name Shot

@export var damage:int = 1
@export var sight:Area2D
@export var target:String = "enemy"
@export var acceleration:float = 2200
@export var speed:float = 300
@export var drag:float = 1500
@export var timer:Timer

var direction:Vector2 = Vector2.ZERO

func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)
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
		if not is_instance_valid(body.holder):
			return
		elif body.holder.is_in_group(target):
			var attak:Attack = Attack.new()
			attak.damage = damage
			body.damage(attak)
			velocity = Vector2.ZERO
			extra()
			queue_free()

func extra()->void:
	pass


func _on_timer_timeout() -> void:
	queue_free()
