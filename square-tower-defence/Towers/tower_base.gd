extends Node2D
class_name TowerBase

@export var options:Node2D
@export var outline:TextureRect

var canvasLayer:CanvasLayer

func _ready() -> void:
	if get_tree().get_nodes_in_group("ui").size() >= 0:
		canvasLayer = get_tree().get_first_node_in_group("ui")
		

func _on_click_pressed() -> void:
	if canvasLayer:
		canvasLayer.visible = true


func frost_click() -> void:
	pass # Replace with function body.


func archer_clicked() -> void:
	pass # Replace with function body.


func bomb_clicked() -> void:
	pass # Replace with function body.


func summoner_clicked() -> void:
	pass # Replace with function body.
