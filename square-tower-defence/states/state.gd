extends Node
class_name State

signal transitioned

func enter()->void:
	pass

func exit()->void:
	pass

func update(_delta:float)->void:
	pass

func physicsUpdate(_delta:float)->void:
	pass

func notgonnause()->void: #this is only so I can get rid of the warning message it gives me.
	emit_signal("transitioned")
