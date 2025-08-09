extends Node

signal gold_changed 
var gold : int = 0

signal enemy_killed

var manager : PlayerManager = null

func add_gold(amount : int):
	gold += amount
	gold_changed.emit()
