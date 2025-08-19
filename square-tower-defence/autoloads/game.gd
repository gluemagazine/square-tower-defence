extends Node

signal gold_changed 
var gold : int = 0

signal enemy_killed

signal tower_opened(slot)

var manager : PlayerManager = null

var tracking := Thread.new()

func add_gold(amount : int):
	gold += amount
	gold_changed.emit()
