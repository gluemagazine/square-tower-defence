extends Node

signal gold_changed 
var gold : int = 0

var manager : PlayerManager = null

func _ready() -> void:
	gold_changed.connect(print_gold)

func add_gold(amount : int):
	gold += amount
	gold_changed.emit()

func print_gold():
	print(gold)
