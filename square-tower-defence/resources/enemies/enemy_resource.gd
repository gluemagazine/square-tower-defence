extends Resource
class_name EnemyResource

@export_range(3,20,1) var sides : int = 3
@export var color : Color = Color.WHITE

@export var animations : Dictionary = {
	"walk" = "walk",
	"attack" = "attack",
	"hurt" = "hurt"
}

@export var health : int = 10
@export var damage : int = 10
@export var speed : int = 100

@export var reward : int = 10
