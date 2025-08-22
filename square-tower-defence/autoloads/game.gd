extends Node

signal gold_changed 
var gold : int = 50:
	set(new):
		gold = new
		gold_changed.emit()
@warning_ignore("unused_signal")
signal enemy_killed

signal tower_opened(slot)

signal pause
signal unpause

var manager : PlayerManager = null

var tracking := Thread.new()

var tower_open : bool = false

var game_paused : bool = false:
	set(new):
		game_paused = new
		if game_paused:
			pause.emit()
		else:
			unpause.emit()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		if tower_open:
			tower_opened.emit(null)
			tower_open = false
		elif game_paused:
			game_paused = false
		else:
			game_paused = true

func add_gold(amount : int):
	gold += amount

func subtract_gold(amount : int):
	gold -= amount
