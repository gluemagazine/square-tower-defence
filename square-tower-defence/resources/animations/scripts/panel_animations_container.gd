extends Resource
class_name PanelAnimationContainer

@export var layer_num : int = 1
@export var dimentions : Vector2 = Vector2(20,20)
@export var animations : Array[PanelAnimation]
@export var color : Color = Color.BLACK
@export var starting_material : ShaderMaterial = preload("uid://b0cobtuo68gj7")

@export var starting_values : Dictionary[String,Variant] = {
	"position" : Vector2(0.5,0.5),
	"rotation_angle" : 0.0,
	"edges" : 3,
	"shape_feather" : 0,
	"progress" : 1,
}
