extends Node
class_name HealthComponent

signal death
signal health_changed
signal damaged

@export var health : int = 100
@export var max_health : int = 100

func set_health(value,limited = true):
	if limited:
		health = value
		check()
	else:
		health = value
	health_changed.emit()

func heal(quantity):
	health += quantity
	check()
	health_changed.emit()

func damage(attack: Attack):
	health -= attack.damage
	check()
	health_changed.emit()
	damaged.emit()

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
		health_changed.emit()
