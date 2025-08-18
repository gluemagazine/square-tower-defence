extends Resource
class_name PanelAnimation

@export var animation_name : String = "walk"
@export var duration : float = 1
@export var loop : bool = false

@export var properties : Array[PropertyAnimation]

@export var played : bool = false

@export var on_secondary : bool = false
@export var mirror_animation : bool = false
@export var secondary_animation : PanelAnimation = null
