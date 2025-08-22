extends Resource
class_name Upgrade

@export var properties : Array[PropertyUpgrade] = []

@export var description : String = "Do a thing"

@export var cost : int = 100

func apply(tower : TowerResource):
	for property in properties:
		property.apply(tower)
