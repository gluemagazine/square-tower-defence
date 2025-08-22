extends Resource
class_name Upgrade

@export var properties : Array[PropertyUpgrade] = []

@export var description : String = "Do a thing"

func apply(tower : TowerResource):
	for property in properties:
		property.apply(tower)
