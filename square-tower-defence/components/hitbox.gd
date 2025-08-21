extends Area2D
class_name HitboxComponent

@export var health_component : HealthComponent
@export var holder:CharacterBody2D

signal freeze(time)

func damage(attack : Attack):
	if attack.freeze:
		freeze.emit(attack.freeze_duration)
	if health_component:
		health_component.damage(attack)
	else:
		return false
