extends Node2D
class_name PlayerManager
@export var health : HealthComponent

func _ready() -> void:
	health.death.connect(loss)
	Game.manager = self

func damage(attack : Attack):
	health.damage(attack)

func loss():
	print("you lose :/")
