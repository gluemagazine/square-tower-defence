extends State
class_name ShootState

@export var holder:Node2D
@export var sightComp:SightComponent
@export var nextState:State
@export var attackPath:String = "res://Towers/arrow.tscn"

func enter()->void:
	sightComp.updtateTarget()

func update(_delta)->void:
	if sightComp.target:
		var shot:Shot = ResourceLoader.load(attackPath).instantiate()
		get_tree().current_scene.add_child(shot)
		shot.global_position = holder.global_position
		shot.direction = (sightComp.target.global_position-holder.global_position).normalized()
		emit_signal("transitioned",self,nextState.name)
