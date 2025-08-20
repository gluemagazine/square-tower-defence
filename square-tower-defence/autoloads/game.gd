extends Node

signal gold_changed 
var gold : int = 50

signal enemy_killed

signal tower_opened(slot)

var manager : PlayerManager = null

var tracking := Thread.new()

var tower_open : bool = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		if tower_open:
			tower_opened.emit(null)
			tower_open = false

func add_gold(amount : int):
	gold += amount
	gold_changed.emit()
