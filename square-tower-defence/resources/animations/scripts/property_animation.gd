extends Resource
class_name PropertyAnimation

@export_enum("color","position","grid_size",
"rotation_angle","edges","shape_feather","progress") var property : String = "rotation_angle"

@export var invert_on_flip : bool = true

@export var number_animated : bool = true
@export var initial_value : float = 0
@export var final_value : float = 0

@export var initial_color : Color
@export var final_color : Color

@export var start : float = 0
@export var end : float = 1
