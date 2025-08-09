extends Node2D
class_name PlayerManager
@export var health : HealthComponent
@export var info : LevelInfo
@onready var gold: Label = $CanvasLayer/gold
@onready var health_label: Label = $CanvasLayer/health
@onready var health_bar: ProgressBar = $CanvasLayer/health2

func _ready() -> void:
	health.death.connect(loss)
	Game.manager = self
	Game.gold_changed.connect(update_gold)
	Game.gold = info.starting_gold
	Game.gold_changed.emit()
	health.max_health = info.base_max_health
	health.set_health(info.base_health)
	health.health_changed.connect(update_health)
	health_bar.max_value = health.max_health
	health_bar.value = health.health

func update_gold():
	gold.text = "Gold: " + str(Game.gold)

func update_health():
	health_bar.value = health.health

func damage(attack : Attack):
	health.damage(attack)

func loss():
	print("you lose :/")
