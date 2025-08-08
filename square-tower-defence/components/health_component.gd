extends Node
class_name HealthComponent

signal death

@export var health : int = 100
@export var max_health : int = 100

func set_health(value,limited = true):
	if limited:
		health = value
		check()
	else:
		health = value

func heal(quantity):
	health += quantity
	check()

func damage(attack: Attack):
	health -= attack.damage
	check()

func check():
	if health <= 0:
		die()
	else:
		cap_health()

func die():
	health = 0
	death.emit()

func cap_health():
	if health >= max_health:
		health = max_health
