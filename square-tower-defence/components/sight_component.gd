extends Area2D
class_name SightComponent

@export var targetGroup:String = "enemy"
@export var pickClosest:bool = true
@export var storeAll:bool = true
@export var canLeave:bool = false

var target:Node2D
var targets:Array = []

func _ready() -> void:
	area_entered.connect(on_area_entered)

func on_area_entered(body:Node)->void:
	if body is HitboxComponent:
		if body.holder.is_in_group(targetGroup):
			if storeAll:
				targets += [body]
				updtateTarget()

func updtateTarget()->void:
	var closestTarget:CharacterBody2D = null
	for i:CharacterBody2D in targets:
		if closestTarget != null:
			if (closestTarget.global_position-global_position)<i.global_position-global_position:
				closestTarget = i
		else:
			closestTarget = i
	target = closestTarget

func on_area_exited(body:Node)->void:
	if body in targets:
		targets.erase(body)
		if body == target:
			updtateTarget()
