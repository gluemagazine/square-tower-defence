extends Area2D
class_name HitboxComponent

@export var health_component : HealthComponent
@export var holder:CharacterBody2D

func _ready() -> void:
	set_collision_layer_value(2,true)
	set_collision_mask_value(2,true)
	set_collision_layer_value(1,false)
	set_collision_mask_value(1,false)

func damage(attack : Attack):
	if health_component:
		health_component.damage(attack)
	else:
		return false
