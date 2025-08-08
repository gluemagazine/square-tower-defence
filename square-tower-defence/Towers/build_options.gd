extends TextureRect

var currentBase:TowerBase


func _on_close_pressed() -> void:
	currentBase = null
	visible = false


func frostClicked() -> void:
	currentBase.frost_clicked()
	currentBase = null
	visible = false

func archerClicked() -> void:
	currentBase.archer_clicked()
	currentBase = null
	visible = false


func bombClicked() -> void:
	currentBase.bomb_clicked()
	currentBase = null
	visible = false


func summonerClicked() -> void:
	currentBase.summoner_clicked()
	currentBase = null
	visible = false
