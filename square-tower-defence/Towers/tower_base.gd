extends Node2D
class_name TowerBase

@export var outline:TextureRect
@export var costs:PackedInt32Array = [100,100,100,100]
var buildOptions:TextureRect

func _ready() -> void:
	if !outline:
		push_error("You didn't set the outline for the tower base")
	if get_tree().get_nodes_in_group("buildOptions").size() >= 0:
		buildOptions = get_tree().get_first_node_in_group("buildOptions")
		

func _on_click_pressed() -> void:
	if buildOptions:
		outline.self_modulate = Color.WHITE
		for i in range(costs.size()):
			if buildOptions.get_child(i+1).get_child(2):
				if buildOptions.get_child(i+1).get_child(2) is RichTextLabel:
					buildOptions.get_child(i+1).get_child(2).text = "[center]Cost: %s"%[costs[i-1]]
		if "currentBase" in buildOptions:
			buildOptions.currentBase = self
			
		buildOptions.visible = true


func frost_clicked() -> void:
	pass # Replace with function body. 


func archer_clicked() -> void:
	if true:#replace with gold checking logic
		var archer:TowerTemplate = ResourceLoader.load("res://Towers/TowerTemplate.tscn").instantiate()
		get_parent().add_child(archer)
		archer.global_position = global_position
		queue_free()


func bomb_clicked() -> void:
	pass # Replace with function body.


func summoner_clicked() -> void:
	pass # Replace with function body.

func close()->void:
	outline.self_modulate = Color.BLACK
